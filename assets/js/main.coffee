wsUri = "ws://turnt.dev/chat/12/1"; 

$(".enter button").click ->
	window.location.href = "/home"

$("#connect").click ->
	console.log("connect")
	init()

$(".send_msg").click ->
	console.log "Send"
	data = JSON.stringify({
		"type": "text",
		"content": $(".content").val()
	})
	doSend data

$(".send_media").click ->
	console.log "Send Media"
	data = JSON.stringify({
		"type": "media",
		"content": $(".content").val()
	})
	doSend data

init = () -> 
	output = document.getElementById("output"); 
	testWebSocket(); 

testWebSocket = () ->
	websocket = new WebSocket wsUri; 
	websocket.onopen = (evt) -> onOpen(evt)
	websocket.onclose = (evt) -> onClose(evt)
	websocket.onmessage = (evt) -> onMessage(evt) 
	websocket.onerror = (evt) -> onError(evt)

onOpen = (evt) -> 
	writeToScreen("CONNECTED"); 

onClose = (evt) -> 
	writeToScreen("DISCONNECTED"); 

onMessage = (evt) ->
	writeToScreen('<span style="color: blue;">RESPONSE: ' + evt.data+'</span>'); 


onError = (evt) -> 
	writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data); 

doSend = (message) ->
	writeToScreen("SENT: " + message);  
	websocket.send(message); 

writeToScreen = (message) ->
	$(".status").html(message)