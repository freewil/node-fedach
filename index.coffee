fs = require 'fs'
https = require 'https'

###
# FedACH Directory File Format
# https://www.fededirectory.frb.org/download.cfm
###
regex = ///
  ^(.{9})     # 1 = Routing Number
  (.{1})      # 2 = Office Code
  (.{9})      # 3 = Servicing FRB Number
  (.{1})      # 4 = Record Type Code
  (.{6})      # 5 = Change Date
  (.{9})      # 6 = New Routing Number
  (.{36})     # 7 = Customer name
  (.{36})     # 8 = Address
  (.{20})     # 9 = City
  (.{2})      # 10 = State Code
  (.{5})      # 11 = Zipcode
  (.{4})      # 12 = Zipcode Extension
  (.{3})      # 13 = Telephone Area Code
  (.{3})      # 14 = Telephone Prefix Number
  (.{4})      # 15 = Telephone Suffix Number
  (.{1})      # 16 = Institution Status Code
  (.{1})      # 17 = Data View Code
  (.{5})$     # 18 = Filter
///

getCa = do ->
  ca = null
  return (cb) ->
    return cb null, ca if ca
    fs.readFile __dirname + '/frb_ca.pem', (err, data) ->
      return cb err if err
      ca = data
      cb null, ca

module.exports.download = (cb) ->
  getCa (err, ca) ->
    return cb err if err
    opts =
      host: 'www.fededirectory.frb.org'
      path: '/FedACHdir.txt'
      agent: false
      ca: ca
      rejectUnauthorized: false
    
    req = https.request opts, (res) ->
      if res.statusCode isnt 200
        return cb new Error 'Bad status code: ' + res.statusCode
      
      # the server certificate uses an email address in the altnames field
      # so ignore this error    
      if req.connection.authorized isnt false or req.connection.authorizationError isnt 'Hostname/IP doesn\'t match certificate\'s altnames'
        return cb new Error 'Failed verifying server identity'
    
      data = ''
      res.setEncoding 'utf8'
      res.on 'data', (d) ->
        data += d
      res.on 'end', ->
        cb null, data
  
    req.on 'error', (e) ->
      cb e
    req.end()

module.exports.parse = (data) ->
  records = []
  lines = data.split '\r\n'
  while line = lines.shift()
    r = regex.exec line
    if r
      records.push
        routing: r[1]
        office: r[2]
        frb: r[3]
        type: r[4]
        date: r[5]
        newRouting: r[6]
        customer: r[7].trim()
        address: r[8].trim()
        city: r[9].trim()
        state: r[10]
        zip: r[11]
        zipExt: r[12]
        zipFull: r[11] + "-" + r[12]
        phoneArea: r[13]
        phonePrefix: r[14]
        phoneSuffix: r[15]
        phoneFull: "" + r[13] + r[14] + r[15] + ""
        status: r[16]
        dataView: r[17]
        filter: r[18]
  return records
