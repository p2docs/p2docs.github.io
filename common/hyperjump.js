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
        {name:"extra",weight:0.5},
        {name:"type",weight:0.5},
        {name:"href",weight:0.7},
        {name:"hidden",weight:1.2},
        {name:"nudge",weight:0.8},
    ],
});
var $hjSelection = 0;

function hyperjump_dispose() {
    $("#hyperjump input").val("").trigger("input");
    $("#hyperjump").removeClass("hj-force-show");
}

jQuery(function() {
    //return false;
    $("body").append("<nav id=\"hyperjump\"><h1>HyperJump!</h1><input autofocus autocomplete=\"off\" spellcheck=\"off\"><ul id=\"hjresults\"></ul></nav>");
    $("#hjreadybutton").on("click",function(event) {
        $("#hyperjump").addClass("hj-force-show");
        $("#hyperjump input").trigger("focus");
    });
    $("body").on("keydown", function(event) {
        let hjActive = $("#hyperjump input").val != "" || $("#hyperjump.hj-force-show").count != 0;
        if(event.keyCode == 16||event.keyCode==17||event.keyCode==18||event.ctrlKey) return null; // Ignore modifiers
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
            $("#hjresults a.hjrsel li").trigger("click");
            event.preventDefault();
        } else if (hjActive && event.keyCode == 27) { // escape
            hyperjump_dispose();
            event.preventDefault();
        } else {
            if (document.activeElement.tagName != "INPUT" && document.activeElement.tagName != "TEXTAREA") {
                $("#hyperjump input").trigger("focus");
            }
        }
    })
    $("nav#hyperjump").on("click", function(event){
        // Clear search if background or result clicked
        if (event.target == this) {
            hyperjump_dispose();
        }
    })

    function updateSelHighlight(list,num) {
        list.children().removeClass("hjrsel").eq(num).addClass("hjrsel");
    }

    $("#hyperjump input").on("input",function() {
        var val = $(this).val();
        var hjnav = $("#hyperjump");
        var list = $("#hjresults");
        $hjSelection = 0;
        if (val=="") {
            list.empty();
            hjnav.removeClass("hjvisible");
        } else {
            hjnav.addClass("hjvisible");
            let searchHeight = hjnav.height() - list.position().top - 12;
            list.append("<a><li id=\"hjdummyresult\">Something went very wrong</li></a>");
            let itemHeight = $("#hjdummyresult").outerHeight(true);
            list.empty();
            console.log(itemHeight);
            let searchMax = Math.max(2,Math.floor(searchHeight/itemHeight));
            //console.log(searchHeight,searchMax);
            const resultList = $hyperFuse.search(val,{limit: searchMax});
            resultList.forEach((res)=>{
                const item = res.item;
                //console.log(res);
                let result = "<span class=\"hjrt\">"+item.name+"</span>";
                if (item.extra) result += " <span class=\"hjrte\">"+item.extra+"</span>";
                if (item.type) result += " - "+item.type;
                list.append("<a href=\""+item.href+"\"><li>"+result+"</li></a>");
            });
            if (resultList.length == 0) {
                list.append("No results :(");
            }
            updateSelHighlight(list,$hjSelection);
            $("#hjresults a").on("click", function(event){
                console.log(event)
                // Clear search if result clicked (fixes intra-page jump)
                hyperjump_dispose();
            })
        }
    });
    $("body").addClass("hyperjump-ready");
});
