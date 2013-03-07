# fedach

[![Build Status](https://travis-ci.org/freewil/node-fedach.png)](https://travis-ci.org/freewil/node-fedach)

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
  var results = fedach.parse(data);
  console.log(results[0]);
});
```

```js
{ 
  routing: '011000015',
  office: 'O',
  frb: '011000015',
  type: '0',
  date: '020802',
  newRouting: '000000000',
  customer: 'FEDERAL RESERVE BANK',
  address: '1000 PEACHTREE ST N.E.',
  city: 'ATLANTA',
  state: 'GA',
  zip: '30309',
  zipExt: '4470',
  zipFull: '30309-4470',
  phoneArea: '866',
  phonePrefix: '234',
  phoneSuffix: '5681',
  phoneFull: '8662345681',
  status: '1',
  dataView: '1',
  filter: '     ' 
}
```
