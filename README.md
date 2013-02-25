# fedach

[![Build Status](https://secure.travis-ci.org/freewil/node-fedach.png)](https://secure.travis-ci.org/freewil/node-fedach)

Parse FedACH Directory File Format for Node.js

## Install

```
npm install fedach
```

## Usage

```js
var fedach = require('fedach');

fedach.download(function(err, data) {
  if (err) return console.error(err);
  var json = fedach.parse(data);

  // save the json data or something
});
```
