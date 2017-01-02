// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/


  
  function markCircle(element) {
    element.classList.toggle("marked");
    checkForBingo();
  }
  
  function alwaysMarkCircle(element) {
    element.classList.add("marked");    
    checkForBingo();
  }
  
  function unMarkCircle(element) {
    element.classList.remove("marked");    
    checkForBingo();
    
  }
  
  function checkForBingo() {
    a = CheckBingo(DOMCircles);
    a.initialize();
    setTimeout(function() {
      a.work();
      setTimeout(function(){
        if(a.num_bingos > 0) {
          showBingo();
        }
      },1);
    }, 1);
  }
  
  function responseIsMarked(element) {
    if (element.value != "" ) {
      alwaysMarkCircle(element.parentElement.parentElement.parentElement);
    } else {
      unMarkCircle(element.parentElement.parentElement.parentElement);
    }
  }
  
  function showBingo() {
    var element = document.getElementById("show-bingo");
    element.style.opacity = 1;
    setTimeout(function() {
      element.style.opacity = 0; 
    }, 5000);
    
  }
  
  function DOMCircles(){
    // assume only one table on the page
    var card = {
      circles: [],
      size: 0,
      num_bingos: 0
    }
    
    card.initialize = function() {
      card.circles = document.getElementsByTagName("td"); 
      
      setTimeout(function() {
        card.size = Math.sqrt(card.circles.length);
      }, 0);
    }
    // returns an Array [x, y], corresponding to the positions x & y of a circle
    //
    // circle = Element type TD with id of bingo-x-y
    //
    // returns an Array
    card.position = function(circle) {
      var array = circle.id.split("-");
      array.shift();
      for(var i=0; i<array.length;i++) array[i] = +array[i];
      return array;
    }
    
    card.circleMarked = function(circle) {
      return circle.classList.contains("marked");
    }
    
    card.markPartOfBingo = function(circle) {
      return circle.classList.add("part-of-bingo");
    }
    
    card.removeAllPartOfBingo = function() {
      var len = card.circles.length;
      for (i = 0; i < len; i ++) {
        if (card.circles[i].classList.contains("part-of-bingo") ){
          card.circles[i].classList.remove("part-of-bingo");
        }
      }
    }
    
    card.getCircles = function () {
      return card.circles;
    }
    
    card.setBingos = function(num) {
      card.num_bingos = num;
    }
    
    return card;
  }
  
  function CheckBingo(DOMCircles){
    // assume only one table on the page
    var bingo = {
      card: DOMCircles(),
      horizontal: {},
      vertical: {},
      left_bingo: 0,
      right_bingo: 0,
      num_bingos: 0,
    }
    
    bingo.initialize = function() {
      bingo.card.initialize();
      bingo["card_size"] = bingo.card.size;
      bingo["circles"] = bingo.card.getCircles();
    }
    //
    // bingo.initialize = function() {
    //   bingo.card.initialize();
    //   bingo.card.size = bingo.card.size;
    // }
  
  
    
    bingo.work = function() {
      initializeCount();
      checkMarkedCircles();
      bingo.num_bingos = getNumBingos();
    }
    
    function initializeCount(){
      bingo.vertical = {};
      bingo.horizontal = {};
      bingo.left_bingo = 0;
      bingo.right_bingo = 0;
      bingo.num_bingos = 0;
    }
    
    function getNumBingos(){
      bingo.card.removeAllPartOfBingo();
      checkAndMarkLeftXBingo();
      checkAndMarkRightXBingo()
      checkHorizontalBingos();
      checkVerticalBingos();
      return bingo.num_bingos;
    }
    
    function checkAndMarkLeftXBingo(){
      if (bingo.left_bingo === bingo.card.size){
        bingo.num_bingos += 1;
        var len = bingo.circles.length;
        for (i = 0; i < len; i ++) {
          if (partOfLeftBingo(bingo.card.position(bingo.circles[i]))) {
            bingo.card.markPartOfBingo(bingo.circles[i]);
          }
        }
      }
    }
    
    function checkAndMarkRightXBingo(){
      if (bingo.right_bingo === bingo.card.size){
        bingo.num_bingos += 1;
        var len = bingo.circles.length;
        for (i = 0; i < len; i ++) {
          if (partOfRightBingo(bingo.card.position(bingo.circles[i]))) {
            bingo.card.markPartOfBingo(bingo.circles[i]);
          }
        }
      }
    }
    
    function checkVerticalBingos(){
      for(var propertyName in bingo.vertical) {
        if (bingo.vertical[propertyName] === bingo.card.size) {
          bingo.num_bingos += 1;
          var len = bingo.circles.length;
          for (i = 0; i < len; i ++) {
            if (bingo.card.position(bingo.circles[i])[0].toString() === propertyName ){
              bingo.card.markPartOfBingo(bingo.circles[i]);
            }
          }
        }
      }
    }
    
    function checkHorizontalBingos(){
      for(var propertyName in bingo.horizontal) {
        if (bingo.horizontal[propertyName] === bingo.card.size) {
          bingo.num_bingos += 1;
          var len = bingo.circles.length;
          for (i = 0; i < len; i ++) {
            if (bingo.card.position(bingo.circles[i])[1].toString() === propertyName) {
              bingo.card.markPartOfBingo(bingo.circles[i]);
            }
          }
        }
      }
    }
      
    function checkMarkedCircles () {
      var len = bingo.circles.length;
      for (var i = 0; i < len; i ++ ) {
        if (bingo.card.circleMarked(bingo.circles[i])) {
          updateMarkedCircles(bingo.card.position(bingo.circles[i]));
        }
      }
    }
    
    function updateMarkedCircles(arrXY){
      var x = arrXY[0].toString();
      var y = arrXY[1].toString();
      if (bingo.vertical.hasOwnProperty(x)){
        bingo.vertical[x] += 1;
      } else {
        bingo.vertical[x] = 1;
      }
      if (bingo.horizontal.hasOwnProperty(y)){
        bingo.horizontal[y] += 1;
      } else {
        bingo.horizontal[y] = 1;
      }
      
      if (partOfLeftBingo(arrXY)){
        bingo.left_bingo += 1
      }
      
      if (partOfRightBingo(arrXY)){
        bingo.right_bingo += 1
      }
    
    }
    
  // # check if these indexes are part of a left-most X bingo
  // #
  // # arrXY[0] - Integer
  // # arrXY[1] = y - Integer
  // #
  // # returns boolean
    function partOfLeftBingo(arrXY) {
      return (arrXY[0] === arrXY[1]);
    }
    
  // # check if these indexes are part of a left-most X bingo
  // #
  // # x - Integer
  // # y - Integer
  // #
  // # returns boolean
  // #
  // # e.g.:  solutions with a size of 5
  // #        (0, 4), (1, 3), (2, 2), (3, 1), (4, 0)
  // #  --> true
    function partOfRightBingo(arrXY) {
      return (arrXY[0] === (bingo.card.size - arrXY[1] - 1));
    }
    
    
    return bingo;
  }