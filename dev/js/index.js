(function ( window ) {

    var headElem = document.getElementsByTagName("head"),
      prototypeVersion = parseInt(new URL(document.location).searchParams.get('v') || 1);
    headElem[0].innerHTML += '<link type="text/css" rel="stylesheet" href="../css/index.css?v=' + prototypeVersion + '"/>';

    document.addEventListener("DOMContentLoaded",function () {
      var headElem = document.getElementsByTagName("head");
      // document.querySelector('body.branding-invision').style.background='#ffffff !important'
      headElem[0].innerHTML += '<style>body.mobile {background: #ffffff !important;}</style>'
    })


})( window );