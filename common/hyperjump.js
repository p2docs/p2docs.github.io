"use strict";

/*let $hyperJumpList = [
    {
        name: "TESTB",
        type: "Instruction",
        href: "/ohno.html",
    },{
        name: "MERGEW",
        type: "Instruction",
        href: "/lmao.html",
    },
];*/

let $hyperFuse = new Fuse($hyperJumpList,{
    keys: [
        {name:"name",weight:1},
        {name:"type",weight:0.3},
    ],
});
var $hjSelection = 0;

jQuery(function() {
    $("body").append("<div id=\"hyperjump\"><h1>HyperJump!</h1><input autofocus autocomplete=\"off\" spellcheck=\"off\"><ul id=\"hjresults\"></ul></div>");
    $("body").on("keydown", function(event) {
        let hjActive = $("#hyperjump input").val != "";
        if(event.keyCode == 16||event.keyCode==17||event.keyCode==18||event.ctrlKey) return; // Ignore modifiers
        else if (hjActive && event.keyCode == 38) { // arrow up
            if ($hjSelection > 0) {
                updateSelHighlight($("#hjresults"),--$hjSelection);
            }
            event.preventDefault();
        } else if (hjActive && event.keyCode == 40) { // arrow down
            var list = $("#hjresults");
            if ($hjSelection < list.children().length-1) {
                updateSelHighlight($("#hjresults"),++$hjSelection);
            }
            event.preventDefault();
        } else if (hjActive && event.keyCode == 13) { // enter
            $("#hjresults a.hjrsel li").click();
            event.preventDefault();
        } else if (hjActive && event.keyCode == 27) { // escape
            $("#hyperjump input").val("").trigger("input");
            event.preventDefault();
        } else {
            $("#hyperjump input").trigger("focus");
        }
    })
    function updateSelHighlight(list,num) {
        list.children().removeClass("hjrsel").eq(num).addClass("hjrsel");
    }

    $("#hyperjump input").on("input",function() {
        var val = $(this).val();
        var list = $("#hjresults");
        list.empty();
        $hjSelection = 0;
        if (val=="") {
            $("#hyperjump").removeClass("hjvisible");
        } else {
            $("#hyperjump").addClass("hjvisible");
            let searchHeight = $(window).height() - list.position().top - 12;
            const itemHeight = 43; // As measured...
            let searchMax = Math.max(2,Math.floor(searchHeight/itemHeight));
            console.log(searchHeight,searchMax);
            const resultList = $hyperFuse.search(val,{limit: searchMax});
            resultList.forEach((res)=>{
                const item = res.item;
                //console.log(res);
                list.append("<a href=\""+item.href+"\"><li><span class=\"hjrt\">"+item.name+"</span> - "+item.type+"</li></a>");
            });
            if (resultList.length == 0) {
                list.append("No results :(");
            }
            updateSelHighlight(list,$hjSelection);
        }
    });
});
