
$(document).ready(function() {

	buildTable(data);
	showMetadata();
	exposeJson();

	// setup the sorting
	$('td').droppable({
		hoverClass: 'hover'
	});
	$('#dustbin').droppable({
		hoverClass: 'hover'
	});
	$('tr').sortable({
		handle: $(this).find('h2'),
		update : function () {
			jsonify();
		}
	});
	$('ul').sortable({ 
		connectWith: 'ul',
		update : function () {
			jsonify();
		}
	});

	// setup the editting
	$('li.card').live("dblclick", function(ev){
		var card = $(this);
		card.toggleClass('edit');
		
		if(card.hasClass('edit')){
			var txt = card.text();
			var input = $("<input type='text' value='"+ txt +"'>");
			card.html(input);
			input.select();
		} else {
			setTitle(card);
		}
	});
	$('input').live('keypress', function(ev){
		if(ev.which == 13) {
			setTitle($(ev.target).parent());
		}
	});

	// add another card.
	$('a.add').click(function(){
		var first = $($('td').get(0));
		$('ul', first).prepend('<li class="card">new</li>');
		return false;
	});
	$('a.addCategory').click(function(){
		$('tr').append('<td><h2 class="title">new</h2><ul id="new"></ul></td>');
		resizeColumns();
		makeSortable();
		return false;
	});
	
	//category renaming.
	$('h2.title').live("dblclick", function(ev){
		var cat = $(this);
		cat.toggleClass('edit');
		if(cat.hasClass('edit')){
			var txt = cat.text();
			var input = $("<input type='text' value='"+ txt +"'>");
			var btn = $("<a href='#' class='delete' title='Delete this column'>delete column</a>");
			btn.click(function(){
				$(this).parents('td').remove();
				resizeColumns();
				return false;
			});
			cat.html(input).append(btn);
			input.select();
		} else {
			setTitle(cat);
		}
	});
	
	// import / export.
	$('#toggleImport').click(function(){
		$('#dataSource').slideToggle();
		return false;
	});
	$('#import').click(function(){
		data = $.evalJSON($('#json').val());
		buildTable(data);
		showMetadata();
		exposeJson();
		$.ajax({
			url: uri,
			type: "put",
			data: "board=" +$('#json').val(),
			dataType: "json"
		});
		return false;
	});
	
	// deleting boards
	$('#delete').click(function(){
		$.ajax({
			url: document.location.href,
			type: "delete",
			success: function(){ document.location.href = "/boards"; }
		});
		return false;
	});

});

function setTitle(place){
	var txt = place.find('input').val();
	place.html(txt);
	jsonify();	
}

function showMetadata() {
	$('#prospects').text(data.title);
	// $('dd.modifier').text(data.modifier);
	$('dd.modified').text(data.modified);
}

function makeSortable() {
	
	$('td').droppable({
		hoverClass: 'hover'
	});

	$('#dustbin').droppable({
		hoverClass: 'hover'
	});

	$('tr').sortable({
		handle: $(this).find('h2'),
		update : function () {
			jsonify();
		}
	});

	$('ul').sortable({ 
		connectWith: 'ul',
		update : function () {
			jsonify();
		}
	});
}


function jsonify() {
	data.cards = [];
	data.categories = [];
	now = new Date();
	data.modified = now.getDate() + "/" + now.getMonth() + "/" + now.getFullYear() +" at "+ now.getHours() + ":" + now.getMinutes();
	$('table ul').each(function(index) {
		var category = $(this).prev().text();
		data.categories.push(category);
		$('li', $(this)).each(function(index) {
			var card = {name: $(this).text(), categories: category};
			data.cards.push(card);
		});
	});

	// and reflect the changed to the metadata in the UI.
	showMetadata();
	exposeJson();

	//now put the json data back to the server.
	$.ajax({
		url: uri,
		type: "put",
		data: "board=" + $.toJSON(data),
		dataType: "json"
	});
}


function buildTable(data) {

	// build the bpard and the columns
	var tbl = $('<table><tr></tr></table>');
	for (var c=0; c < data.categories.length; c++) {
		var td = $("<td><h2 class='title'>"+ data.categories[c] +"</h2><ul id='"+ data.categories[c] +"'></ul></td>");
		$('tr', tbl).append(td);
	};
	$('#board').empty().append(tbl);
	
	// populate the board with the data.
	for (var c=0; c < data.cards.length; c++) {
		var col = $('#'+data.cards[c].categories);
		var card = "<li class='card>"+data.cards[c].name +"</li>";	
		col.append(card);
	}
	resizeColumns();
}

function resizeColumns(){
	var cols = $("td");
	cols.width((100 / cols.length) + "%");
}

function exposeJson(){
	$('#json').val($.toJSON(data));	
}








