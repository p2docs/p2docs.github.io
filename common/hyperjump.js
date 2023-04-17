"use strict";

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
    $("#hyperjump input").val("").trigger("input").trigger("blur");
    $("#hyperjump").removeClass("hj-force-show");
}

jQuery(function() {
    //return false;
    $("body").append("<nav id=\"hyperjump\"><h1>HyperJump!</h1><input autocomplete=\"off\" spellcheck=\"off\"><ul id=\"hjresults\"></ul><div id=\"hjhint\">Welcome to <i>HyperJump!</i><br>Start typing to search for content.<br>This prompt opens automatically if you start typing, at any time.<br>Click anywhere or press ESC to close.</div></nav>");
    $("#hjreadybutton").on("click",function(event) {
        $("#hyperjump").addClass("hj-force-show");
        $("#hyperjump input").trigger("focus");
    });
    $("body").on("keydown", function(event) {
        let hjActive = $("#hyperjump input").val() != "" || $("#hyperjump.hj-force-show").length != 0;
        if (event.ctrlKey) return;
        switch (event.keyCode) {
        case 16:
        case 17:
        case 18:
            return null; // Ignore modifiers
        case 38: // arrow up
            if (hjActive) {
                if ($hjSelection > 0) {
                    updateSelHighlight($("#hjresults"),--$hjSelection);
                }
                event.preventDefault();
            }
            break;
        case 40:
            if (hjActive) {
                var list = $("#hjresults");
                if ($hjSelection < list.children().length-1) {
                    updateSelHighlight($("#hjresults"),++$hjSelection);
                }
                event.preventDefault();
            }
            break;
        case 13:
            if (hjActive) {
                $("#hjresults a.hjrsel li").trigger("click");
                event.preventDefault();
            }
            break;
        case 27:
            if (hjActive) { // escape
                hyperjump_dispose();
                event.preventDefault();
            }
            break;
        default:
            if (document.activeElement.tagName != "INPUT" && document.activeElement.tagName != "TEXTAREA") {
                $("#hyperjump input").trigger("focus");
            }
            break;
        }
    });
    $("nav#hyperjump").on("click", function(event){
        // Clear search if background or result clicked
        if (event.target == this) {
            hyperjump_dispose();
        }
    });

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
            if ($("#hyperjump.hj-force-show").length == 0) {
                $(this).trigger("blur");
            }
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
