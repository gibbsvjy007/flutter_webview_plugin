var open = window.XMLHttpRequest.prototype.open;
var send = window.XMLHttpRequest.prototype.send;
var onReadyStateChange;
var index = 0;
function openReplacement(method, url, async, user, password) {
    var syncMode = async !== false ? 'async' : 'sync';
    if (url === '/api/getFareEstimates') {
        console.log('Preparing UBER fare call' + syncMode + ' HTTP request : ' + method + ' ' + url);
    }

    if (url.indexOf('https://book.olacabs.com/data-api/category-fare/p2p') === -1) {
        console.log('Preparing OLA call' + syncMode + ' HTTP request : ' + method + ' ' + url);
    }

    return open.apply(this, arguments);
}

function sendReplacement(data) {
    console.log('Sending HTTP request data : ');
    console.log(JSON.stringify(data));

    if (this.onreadystatechange) {
        this._onreadystatechange = this.onreadystatechange;
    }
    this.onreadystatechange = onReadyStateChangeReplacement;
    return send.apply(this, arguments);
}

function onReadyStateChangeReplacement() {
   console.log('HTTP request ready state changed : ' + this.readyState + ' ' + this.readyState + ' - ' + this.responseType +  ' ' + XMLHttpRequest.DONE);
   console.log(this.responseURL);
    if (this.readyState === XMLHttpRequest.DONE) {
        if (this.responseType === 'text') {
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
        if (this.responseType === 'json') {
               console.log('________________response of OLA____________');
               console.log(JSON.stringify(this.response));
               var res = JSON.stringify(this.response);
               if (res !== '' && res !== null && res.indexOf('price') !== -1) {
                   var oData = {'data': res};
                   console.log(oData);
                   if (window.Android && window.Android.postMessage) {
                        Android.postMessage(res);
                   }
               }
               if (this.responseURL !== "" && this.responseURL.indexOf('category-availability')) {
                    index++;
                    console.log('________________category-availability____________');
                    if (index < 3) {
                       var res = JSON.stringify(this.response);
                       console.log(res);
                       if (window.Android && window.Android.postMessage) {
                            Android.postMessage(res);
                       }
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
