$(function() {
	
	/* ********** SUPERFISH MENU ********** */
	$("ul#mainNav").superfish({ 
		delay:       50,                              // delay on mouseout 
		animation:   {opacity:'show',height:'show'},  // fade-in and slide-down animation 
		speed:       'fast',                          // faster animation speed 
		autoArrows:  false,                           // disable generation of arrow mark-up 
		dropShadows: false                            // disable drop shadows 
	});

	/* ********** BACKGROUND CHANGER ********** */
	$('a.bg-changer').click(function(event){
		event.preventDefault();
		var background = $(this).attr('data-background');
		$('body').removeClass("default dark_mosaic dark_wood dark_linen dark_stripes dark_leather").addClass(background);
	});
	
	/* ********** BACK TO TOP BUTTON ********** */
	$(window).scroll(function() {
		if($(this).scrollTop() != 0) {
			$('#toTop').fadeIn('slow');	
		} else {
			$('#toTop').fadeOut('fast');
		}
	});
	$('#toTop').click(function() {
		$('body,html').stop().animate({scrollTop:0},800,'easeOutExpo');
	});
	
	/* ********** LIGHTBOX PLUGIN ********** */
	$('.lightbox').lightbox();
	
	/* ********** BLACK & WHITE PLUGIN ********** */
	$(window).load(function(){
		$('.bwWrapper').BlackAndWhite({
			webworkerPath : 'js/',
			responsive:true,
			speed: { //this property could also be just speed: value for both fadeIn and fadeOut
				fadeIn: 200, // 200ms for fadeIn animations
				fadeOut: 800 // 800ms for fadeOut animations
			}
		});
	});
	
	/* ********** SCROLL-TO BUTTON ********** */
	$('.scrollTo').click(function() {
		$(this).parents('ul').children().removeClass('active');
		$(this).closest('li').addClass('active');
		var elementToScroll = $('#' + $(this).attr('href').substring(1));
		var offset = elementToScroll.offset();
		$('body,html').stop().animate({scrollTop:offset.top},800,'easeOutExpo');
	});
	
	/* ********** SEQUENCE SLIDER ********** */
	if ($('#sequence').length) {
		var options = {
            autoPlay: true
			, autoPlayDelay: 3000
			, animateStartingFrameIn: true
			, transitionThreshold: 1500
        }
		var sequence = $("#sequence").sequence(options).data("sequence");
	}
	
	/* ********** NIVO SLIDER ********** */
	$(window).load(function() {
		$('#slider').nivoSlider({
			effect: 'random', // sliceDown, sliceDownLeft, sliceUp, sliceUpLeft, sliceUpDown, sliceUpDownLeft, fold, fade, random, slideInRight, slideInLeft, boxRandom, boxRain, boxRainReverse, boxRainGrow, boxRainGrowReverse, random
			slices: 15, // For slice animations
			boxCols: 8, // For box animations
			boxRows: 4, // For box animations
			animSpeed: 500, // Slide transition speed
			pauseTime: 4000, // How long each slide will show
			startSlide: 0, // Set starting Slide (0 index)
			directionNav: false, // Next & Prev navigation
			controlNav: true, // 1,2,3... navigation
			controlNavThumbs: false, // Use thumbnails for Control Nav
			controlNavThumbsFromRel: false, // Use image rel for thumbs
			keyboardNav: true, // Use left & right arrows
			pauseOnHover: true, // Stop animation while hovering
			manualAdvance: false, // Force manual transitions
			captionOpacity: 1, // Universal caption opacity
			randomStart: false, // Start on a random slide
			afterLoad: function(){$('#slider .nivo-caption').addClass('animateIn')},    
			beforeChange: function(){$('#slider .nivo-caption').removeClass('animateIn').addClass('animateOut')},
			afterChange: function(){$('#slider .nivo-caption').removeClass('animateOut').addClass('animateIn')}
		});
	});
	
	/* ********** ISOTOPE ********** */
	$('#portfolio_selector').fadeOut(0);
	$(window).load(function () {
		if ($('#portfolio_container').length) {
			var $container = $('#portfolio_container');
			$container.equalize('height');
			$container.isotope();
			$('#portfolio_selector').fadeIn(500);
			$('#portfolio_selector a').click(function(){
				var selector = $(this).attr('data-filter');
				$container.isotope({ filter: selector });
				$('#portfolio_selector a').removeClass('active');
				$(this).addClass('active');
				return false;
			});
		}
	});
	
	/* ********** CAROUSEL ********** */
	    $('.carousel').carousel({
			interval: 3000
		})
	
	/* 
	********** MAKE ALERT ON MOBILE DEVICES that they can cause anchor links to stop working VISIBLE  ********** 
	********** page: aboutus, element: sidenav affix  **********
	*/
	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
		$('#mobile-alert').css('display','block');
	}
	
	/* ********** MAPS ********** */
	if ($('#map_canvas').length) {
		
		var mapStyles = [
			{ featureType: "administrative", elementType: "all", stylers: [ { saturation: -70 } ] },
			{ featureType: "landscape", elementType: "all", stylers: [ { saturation: -70 } ] },
			{ featureType: "poi", elementType: "all", stylers: [ { saturation: -70 } ] },
			{ featureType: "road", elementType: "all", stylers: [ { saturation: -70 } ] },
			{ featureType: "transit", elementType: "all", stylers: [ { saturation: -70 } ] },
			{ featureType: "water", elementType: "all", stylers: [ { saturation: -30 } ] }
		];
		
		function marker(markerLatLng, center, zoom) {
			this.markerLatLng = markerLatLng;
			this.center = center;
			this.zoom = zoom;
		}
		
		gmapOptions = new marker();
		gmapOptions.center = [42.658721,18.086017];
		gmapOptions.markerLatLng = [42.658721,18.086017];
		gmapOptions.zoom = 14;
		$("#map_canvas").gmap3(
			{action: 'init',
			options:{
				center:gmapOptions.center, 
				zoom:gmapOptions.zoom,
				scrollwheel: false
				}
			},
			{action:'addMarker',
				latLng:gmapOptions.markerLatLng
			}
		);
		
		$("#map_canvas").gmap3(
			{action: 'setStyledMap',
				styledmap:{
				  id: 'style1',
				  style: mapStyles,
				  options:{
					name: 'Style 1'
				  }
				}
			}
		);
		
		$('.seeMap').click(function(event){
			event.preventDefault();
			
			// clear all markers
			$('#map_canvas').gmap3({action:'clear'});
			
			// add new marker
			var newMarker = new marker();
			newMarker.markerLatLng = $(this).attr('data-marker').split(",");
			newMarker.center = $(this).attr('data-marker').split(",");
			newMarker.zoom = parseInt($(this).attr('data-zoom'));
			$("#map_canvas").gmap3(
				{action:'addMarker',
					latLng:newMarker.markerLatLng,
					map:{
						//center: true,
						zoom: newMarker.zoom
					}
				},
				{action:'panTo',
					args:[ new google.maps.LatLng(newMarker.markerLatLng[0],newMarker.markerLatLng[1]) ]
				}
			);
		});
	}
});