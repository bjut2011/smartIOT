#include "re_thread.h"
#include<stdlib.h>
#include<pthread.h>
#include<sys/socket.h>
#include<sys/types.h>       //pthread_t , pthread_attr_t and so on.
#include<stdio.h>
#include<netinet/in.h>      //structure sockaddr_in
#include<arpa/inet.h>       //Func : htonl; htons; ntohl; ntohs
#include<assert.h>          //Func :assert
#include<string.h>          //Func :memset
#include<unistd.h>          //Func :close,write,read
#include "util.h"
#include "ddp.h"
#define SOCK_PORT 24912

static void Data_handle(void * sock_fd){
   int fd = *((int *)sock_fd);
   int i_recvBytes;
    BYTE data_recv[BUFFER_LENGTH];
 
    while(1)
      {
         printf("waiting for request...\n");
         //Reset data.
        memset(data_recv,0,BUFFER_LENGTH);
 
        i_recvBytes = read(fd,data_recv,BUFFER_LENGTH);
         if(i_recvBytes == 0)
         {
             printf("Maybe the client has closed\n");
            break;
         }
        if(i_recvBytes == -1)
        {
             fprintf(stderr,"read error!\n");
           break;
        }
        int j=0;
        for(;j<i_recvBytes;j++){
          printf("%02x",data_recv[j]);
        }
        printf("\n");
        BYTE data_send[BUFFER_LENGTH];
        memset(data_send,0,BUFFER_LENGTH);
        if(data_recv[0]==0x7B){
            int len = VerifyDDPFrame(data_recv,i_recvBytes,0,data_send);
             int k=4;
             for(;k<15;k++){
               data_send[k]=data_recv[k];
             }
             send(fd,data_send,len,0);
             k=0;
             printf("reg send:");
             for(;k<len;k++){
               printf("%02x",data_send[k]);
             }
             printf("\n");
        }
        else{
          printf("101\n");
          VerifyIED101Frame(data_recv,i_recvBytes,0);
          data_send[0]=0x0B;
          send(fd,data_send,1,0);
        }
        //send(fd,data_send,1,0);
        //if(write(fd,data_send,1) == -1)
         //{
         //   break;
         //}
     }
 
   //Clear
     printf("terminating current client_connection...\n");
     close(fd);            //close a file descriptor.
     pthread_exit(NULL);   //terminate calling thread!
}


void
thread_re(void *arg)
{
    int sockfd_server;
    int sockfd;
    int fd_temp;
    struct sockaddr_in s_addr_in;
    struct sockaddr_in s_addr_client;
    int client_length;

    sockfd_server = socket(AF_INET,SOCK_STREAM,0);  //ipv4,TCP
    assert(sockfd_server != -1);

//before bind(), set the attr of structure sockaddr.
    memset(&s_addr_in,0,sizeof(s_addr_in));
    s_addr_in.sin_family = AF_INET;
    s_addr_in.sin_addr.s_addr = htonl(INADDR_ANY);  //trans addr from uint32_t host byte order to network byte order.
    s_addr_in.sin_port = htons(SOCK_PORT);          //trans port from uint16_t host byte order to network byte order.
    fd_temp = bind(sockfd_server,(struct scokaddr *)(&s_addr_in),sizeof(s_addr_in));
    if(fd_temp == -1)
    {
      fprintf(stderr,"bind error!\n");
      exit(1);
    }

    fd_temp = listen(sockfd_server,MAX_CONN_LIMIT);
    if(fd_temp == -1)
    {
      fprintf(stderr,"listen error!\n");
       exit(1);
    }

    while(1)
    {
      printf("waiting for new connection...\n");
      pthread_t thread_id;
      client_length = sizeof(s_addr_client);
 
      //Block here. Until server accpets a new connection.
      sockfd = accept(sockfd_server,(struct sockaddr_*)(&s_addr_client),(socklen_t *)(&client_length));
      if(sockfd == -1)
      {
        fprintf(stderr,"Accept error!\n");
        continue;                               //ignore current socket ,continue while loop.
      }
      printf("A new connection occurs!\n");
      if(pthread_create(&thread_id,NULL,(void *)(&Data_handle),(void *)(&sockfd)) == -1)
      {
        fprintf(stderr,"pthread_create error!\n");
        break;                                  //break while loop
      }
    }
 
    //Clear
    int ret = shutdown(sockfd_server,SHUT_WR); //shut down the all or part of a full-duplex connection.
    assert(ret != -1);
 
    printf("Server shuts down\n");



 
}
