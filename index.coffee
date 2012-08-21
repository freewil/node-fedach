###
# FedACH Directory File Format
# https://www.fededirectory.frb.org/download.cfm

# All Fields are available using camel-cased properties
###

{readFile} = require 'fs'

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


module.exports =
  parse: (filename, cb) ->
    readFile filename, 'utf8', (err, data) ->
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
      cb null, records
