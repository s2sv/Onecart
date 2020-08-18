// # app/assets/javascripts/autocomplete.js



document.addEventListener("turbolinks:load", function() {

function initializeAutocomplete1(id) {     
     var element = document.getElementById(id);
     if (element) {
       var autocomplete = new google.maps.places.Autocomplete(element, { componentRestrictions: {country: 'za'} });
       // CH You removed type geocode above to get business / complex name search working  
       google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
        
       }
}

function initializeAutocomplete2(id) {     
     var element = document.getElementById(id);
     if (element) {
var autocomplete2 = new google.maps.places.Autocomplete(element, { componentRestrictions: {country: 'za'} });
       google.maps.event.addListener(autocomplete2, 'place_changed', onPlaceChanged2);

       }
}

function onPlaceChanged() 
{
     var place = this.getPlace();
     var faddress = place.formatted_address; 
     var lat = place.geometry.location.lat();
     var lng = place.geometry.location.lng();
     var fname = place.name; 

     console.log(place);  // Uncomment this line to view the full object returned by Google API.     
     console.log(faddress);
     console.log(lat);
     console.log(lng);
     console.log(fname);

     var faddress_element = document.getElementById("from_faddress");
     var lat_element = document.getElementById("from_latitude");
     var lng_element = document.getElementById("from_longitude");
     var fname_element = document.getElementById("from_name");
     

//      format_element.value = format_element;
     faddress_element.value = faddress;
     lat_element.value =  lat;
     lng_element.value = lng;
     fname_element.value = fname; 

for (var i in place.address_components) 
   {
   var component = place.address_components[i];
   for (var j in component.types) 
          {  // Some types are ["country", "political"]
          var type_element = document.getElementById(component.types[j]);
          if (type_element) 
                 {
                 type_element.value = component.long_name;
                 console.log(type_element.value); 
                 }
          }
   }
}  

function onPlaceChanged2() 
{
     var place2 = this.getPlace();
     var faddress2 = place2.formatted_address;  
     var lat2 = place2.geometry.location.lat();
     var lng2 = place2.geometry.location.lng();
     var fname2 = place2.name;

     console.log(place2);  // Uncomment this line to view the full object returned by Google API.  
     console.log(faddress2);
     console.log(lat2);
     console.log(lng2);
     console.log(fname2);

     var lat_element2 = document.getElementById("to_latitude");
     var lng_element2 = document.getElementById("to_longitude");
     var faddress_element2 = document.getElementById("to_faddress");
     var fname_element2 = document.getElementById("to_name");

     faddress_element2.value = faddress2;
     lat_element2.value =  lat2;
     lng_element2.value = lng2;
     fname_element2.value = fname2; 
     

for (var m in place2.address_components) 
   {
   var component2 = place2.address_components[m];
   for (var n in component2.types) 
          {  // Some types are ["country", "political"]
          var type_element2 = document.getElementById("to_" + component2.types[n]);
      
          // type_element2 = "to_" + type_element2;
          if (type_element2) 
                 {
                 type_element2.value = component2.long_name;
                
                 console.log(type_element2.value); 
              
                 }
          }
   }
}   



google.maps.event.addDomListener(window, 'load', function() {

 initializeAutocomplete1('from_autocomplete_address');  
 initializeAutocomplete2('to_autocomplete_address');   


 }); 
}); 


