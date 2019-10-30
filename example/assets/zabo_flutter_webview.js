var open = window.XMLHttpRequest.prototype.open;
var send = window.XMLHttpRequest.prototype.send;
var onReadyStateChange;

function openReplacement(method, url, async, user, password) {
    var syncMode = async !== false ? 'async' : 'sync';
    if (url === '/api/getFareEstimates') {
        console.log('Preparing ' + syncMode + ' HTTP request : ' + method + ' ' + url);
    }
    return open.apply(this, arguments);
}

function sendReplacement(data) {
    console.log('Sending HTTP request data : ', data);

    if (this.onreadystatechange) {
        this._onreadystatechange = this.onreadystatechange;
    }
    this.onreadystatechange = onReadyStateChangeReplacement;
    return send.apply(this, arguments);
}

function onReadyStateChangeReplacement() {
   console.log('HTTP request ready state changed : ' + this.readyState + ' ' + this.readyState + ' ' + XMLHttpRequest.DONE);
    if (this.readyState === XMLHttpRequest.DONE) {
        if (this.responseText !== '' && this.responseText !== null) {
            if (this.responseText.indexOf('fareSessionUUID') !== -1) {
                console.log('________________response____________');
                var oData = JSON.stringify({'data': this.responseText});
                     console.log(oData);
                     if (window.Android && window.Android.postMessage) {
                          Android.postMessage(this.responseText);
                     }
            }
        }
     }
    if (this._onreadystatechange) {
        return this._onreadystatechange.apply(this, arguments);
    }
}


window.XMLHttpRequest.prototype.open = openReplacement;
window.XMLHttpRequest.prototype.send = sendReplacement;
