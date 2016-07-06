$(function() {
    function a(a, b, c) {
        $("<div id='tooltip'>" + c + "</div>").css({
            position: "absolute",
            display: "none",
            top: b + 5,
            left: a + 5,
            border: "1px solid #fdd",
            padding: "2px",
            "background-color": "#fee",
            opacity: .8
        }).appendTo("body").fadeIn(200)
    };
    $(".h5a-sidebar").affix({
        offset: {
            top: 330,
            bottom: function() {
                return this.bottom = $(".bs-footer").outerHeight(!0)
            }
        }
    });
    $("#changeColor").on("click",
    function(a) {
        a.preventDefault();
        var b = ["red", "green", "blue", "violet", "orange", "gray"],
        c = b[Math.floor(Math.random() * b.length)];
        $("#colorChanger").removeClass("red green blue violet orange gray"),
        $("#colorChanger").addClass(c)
    });
    $(".popover-test").popover({
        trigger: "hover",
        html: !0
    });
    $(".tooltip-test").tooltip({
        html: !0
    });
    var myvalues = [10,8,5,7,4,4,1];
    $(".inlinebar").sparkline(myvalues, {
        type: "bar",
        barColor: "white",
        height: "50px",
        barWidth: "10%"
    });
    /*var canvas = document.getElementById("device_id");
    var context = canvas.getContext('2d');
    context.fillStyle = "white";
    context.fillRect(0, 10, 10, 50);
    context.fillRect(11,30, 10, 50);
    context.fillRect(22,40, 10, 50);
    context.fillRect(33,35, 10, 50);
    context.fillRect(33,10, 10, 50);
    context.fillRect(44,30, 10, 50);
    context.fillRect(55,0, 10, 50);*/
    $(".sidenav-stuff").find(".fa-times").on("click",
    function() {
        $(".sidenav-stuff").remove()
    });
    $("#exampleChart").css({
        width: "100%",
        height: "300px"
    });
    var b = [{
        label: "foo",
        color: "rgb(184,214,230)",
        data: [[1, 300], [2, Math.floor(200 * Math.random())], [3, 300], [4, 300], [5, Math.floor(300 * Math.random())]]
    },
    {
        label: "baz",
        color: "rgb(233,233,233)",
        data: [[1, Math.floor(600 * Math.random())], [2, 200], [3, 300], [4, Math.floor(400 * Math.random())], [5, 500]]
    }];
    c = $.plot("#exampleChart", b, {
        series: {
            lines: {
                show: !0
            },
            points: {
                show: !0
            }
        },
        grid: {
            show: 1,
            color: "rgb(210, 210, 210)",
            tickColor: "rgba(220, 220, 220, 1)",
            backgroundColor: "rgb(255,255,255)",
            hoverable: !0,
            clickable: !0
        }
    });
    d = null;
    $("#exampleChart").bind("plothover",
    function(b, c, e) {
        if ($("#enablePosition:checked").length > 0) {
            var f = "(" + c.x.toFixed(2) + ", " + c.y.toFixed(2) + ")";
            $("#hoverdata").text(f)
        }
        if ($("#enableTooltip:checked").length > 0) if (e) {
            if (d != e.dataIndex) {
                d = e.dataIndex,
                $("#tooltip").remove();
                var g = e.datapoint[0].toFixed(2),
                h = e.datapoint[1].toFixed(2);
                a(e.pageX, e.pageY, e.series.label + " of " + g + " = " + h)
            }
        } else $("#tooltip").remove(),
        d = null
    });
    $("#exampleChart").bind("plotclick",
    function(a, b, d) {
        d && ($("#clickdata").text(" - click point " + d.dataIndex + " in " + d.series.label), c.highlight(d.series, d.datapoint))
    });
    for (var b = [], e = (Math.floor(6 * Math.random()) + 3, 0); 3 > e; e++) b[e] = {
        label: "Serie #" + (e + 1),
        data: Math.floor(100 * Math.random()) + 1
    };
    $("#examplePie").css({
        width: "100%",
        height: "70px"
    });
    var f = $("#examplePie");
    f.unbind();
    $("#title").text("Interactivity");
    $("#description").text("The pie can be made interactive with hover and click events.");
    $.plot(f, b, {
        series: {
            pie: {
                show: !0
            }
        },
        grid: {
            hoverable: !0,
            clickable: !0
        }
    });
    f.bind("plothover",
    function(a, b, c) {
        if (c) {
            var d = parseFloat(c.series.percent).toFixed(2);
            $("#hover").html("<span style='font-weight:bold; color:" + c.series.color + "'>" + c.series.label + " (" + d + "%)</span>")
        }
    }),
    f.bind("plotclick",
    function(a, b, c) {
        c && (percent = parseFloat(c.series.percent).toFixed(2), $("#chartsModal .modal-body").html("<p><h4>" + c.series.label + "</h4> <h2>" + percent + "%</h1></p>"), $("#chartsModal").modal("toggle"))
    }),
    $("#exampleStacking").css({
        width: "100%",
        height: "70px"
    });
    var f = $("#exampleStacking");
    f.unbind();
    var b = [];
    b = [{
        label: "foo",
        color: "rgb(184,214,230)",
        data: [[1, 300], [2, Math.floor(200 * Math.random())], [3, 300], [4, 300], [5, Math.floor(300 * Math.random())]]
    },
    {
        label: "baz",
        color: "rgb(233,233,233)",
        data: [[1, Math.floor(600 * Math.random())], [2, 200], [3, 300], [4, Math.floor(400 * Math.random())], [5, 500]]
    },
    {
        label: "bar",
        color: "rgb(197,224,238)",
        data: [[1, 500], [2, 600], [3, 400], [4, Math.floor(300 * Math.random())], [5, 0]]
    }],
    $.plot(f, b, {
        series: {
            stack: 1,
            bars: {
                show: !0,
                barWidth: .4,
                fill: 1
            },
            highlightColor: "white"
        },
        grid: {
            show: !1,
            color: "rgb(255, 255, 255, 1)",
            tickColor: "rgba(255, 255, 255, 1)",
            backgroundColor: "rgb(255, 255, 255)",
            hoverable: !0,
            clickable: !0
        }
    }),
    f.bind("plotclick",
    function(a, b, c) {
        c && ($("#chartsModal .modal-body").html("<p><h2>You clicked: graph with bars!</h1> (and you have the clicked Object here.)<p>"), $("#chartsModal").modal("toggle"))
    }),
    $("#demoProducts").dataTable(),
    $("#demoUsers").dataTable(),
    $(".close_box").on("click",
    function(a) {
        a.preventDefault(),
        alert("Here you could close this box and rearrange the one next to it.")
    }),
    $(".dial").knob(),
    $("#userForm").validate(),
    $("#productForm").validate(),
    $("filePicker").on("click",
    function() {
        filepicker.pick(function(a) {
            console.log(a.url)
        })
    })
});
