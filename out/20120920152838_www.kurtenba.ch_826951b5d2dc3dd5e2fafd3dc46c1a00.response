function insert() {
   var url = document.getElementById('url').value;
   var foo = document.getElementById('foo').value;
   if (url=="") { document.getElementById("status").innerHTML=""; return; } 
   if (window.XMLHttpRequest) xmlhttp=new XMLHttpRequest();
   else  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
   xmlhttp.onreadystatechange=function() {
      if (xmlhttp.readyState==4 && xmlhttp.status==200) {
         document.getElementById("status").innerHTML=xmlhttp.responseText;
         result();
      }
   }
   xmlhttp.open("POST","insert.php?url="+escape(url)+"&foo="+escape(foo));
   xmlhttp.send();
}
function result() {
	alert(1);
   var url = document.getElementById('url').value;
/*   if (window.XMLHttpRequest) xmlhttp=new XMLHttpRequest();
   else  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
   xmlhttp.onreadystatechange=function() {
      if (xmlhttp.readyState==4 && xmlhttp.status==200){ 
         document.getElementById("status").innerHTML=xmlhttp.responseText;
		}
   }
   xmlhttp.open("POST","result.php?url="+escape(url));
   xmlhttp.send();
*/
	$.ajax({
		type: 'POST',
		url: "result.php?url="+escape(url),
		data : "url="+escape(url),
		success: function(html) {
			 $("#status").html(html);
		}
	});

}
/*
function update_helper() {
   var url = document.getElementById('url').value;
   new Ajax.Updater('result', "result.php?url="+escape(url)) {
      method: 'post', 
      insertion: Insertion.Bottom;
   }
}
*/
