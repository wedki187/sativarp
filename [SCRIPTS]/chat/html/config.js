window.addEventListener('message', function(event) {
	if (event.data.type == "hide") {
		document.getElementById("app").children[0].style.display = 'none';
	} else if(event.data.type == "show") {
		document.getElementById("app").children[0].style.display = 'block';
	}
});
