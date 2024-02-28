import smtp, strutils, times, tables, os, strformat
echo "test"

var username = "joelpaiva112233@gmail.com"
var password = "evgffcalurwfspen"
var emailperson = "etienne@tlo.co.za"

proc sendBirthdayEmail(fullname, email: string) =
    echo "testssssss" 
    echo fmt"[+]Sending email to {emailperson} ."
    var msg = createMessage("Dear test {emailperson}" ,
                            "test.\n test",
                            @["foo@gmail.com"])
    let smtpConn = newSmtp(useSsl = true, debug=true)
    smtpConn.connect("smtp.gmail.com", Port 587)
    smtpConn.auth(username, password)
    smtpConn.sendmail(emailperson, @["foo@gmail.com"], $msg)

proc processRow(row: Table[string, string]) =
  echo "testssssss"
  let
    fullName = row.getOrDefault("Fullname", "")
    email = row.getOrDefault("Email", "")
    birthdayStr = row.getOrDefault("Birthday", "")
  
  if fullName != "" and email != "" and birthdayStr != "":
    let
      birthdayDate = parse(birthdayStr, "dd/MM/yyyy", utc())
      today =  now().utc

    if birthdayDate == today and birthdayDate == today:
      sendBirthdayEmail(fullName, email)

proc readCsvAndProcess(filename: string) =
  echo "test 3"
  let lines = readFile(filename).splitLines()

  for i, line in lines:
    if i > 0: # Assuming the first line is headers
      let fields = line.split(',')
      if fields.len >= 3:
        var row = initTable[string, string]()
        row["Fullname"] = fields[0].strip()
        row["Email"] = fields[1].strip()
        row["Birthday"] = fields[2].strip()
        processRow(row)


proc main() =
    let csvFilePath = "test.csv"
    readCsvAndProcess(csvFilePath)

when isMainModule:
    echo "test 2"
    main()