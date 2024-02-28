# You need to import necessary modules. Ensure you have a module that supports SMTP operations.
import os, strformat, times, tables, strutils
# Add your SMTP library import here. This is a placeholder.
# import yourSmtpLibrary

var
  username = "joelpaiva112233@gmail.com"
  password = "evgffcalurwfspen"
  # emailperson variable removed because it's not needed globally.

# Assuming the SMTP library provides these functionalities.
# You will need to replace `createMessage` and `newSmtp` with actual functions from your SMTP library.
proc createMessage(subject, body: string, recipients: seq[string]): string =
  # Implement or use your library's functionality
  return ""

proc newSmtp(useSsl: bool, debug: bool): SmtpConnection =
  # Implement or use your library's functionality
  return SmtpConnection()

type
  SmtpConnection = object
    # Define necessary fields and methods for your SMTP operations.
  
  proc connect(host: string, port: int) = discard
  proc auth(username, password: string) = discard
  proc sendmail(from, to: string, message: string) = discard

proc sendBirthdayEmail(fullname, email: string) =
  echo fmt"[+] Sending email to {email}."
  var msg = createMessage("Happy Birthday!", fmt"Dear {fullname},\n\nWishing you a very happy birthday!", @[email])
  let smtpConn = newSmtp(useSsl = false, debug = true) # Assuming STARTTLS, useSsl is false.
  try:
    smtpConn.connect("smtp.gmail.com", Port = 587)
    smtpConn.auth(username, password)
    smtpConn.sendmail(username, email, msg)
    echo "[+] Email sent successfully."
  except Exception as e:
    echo "[-] Failed to send email: ", e.msg

proc processRow(row: Table[string, string]) =
  let
    fullName = row.getOrDefault("Fullname", "")
    email = row.getOrDefault("Email", "")
    birthdayStr = row.getOrDefault("Birthday", "")
  
  if fullName != "" and email != "" and birthdayStr != "":
    let
      birthdayDate = parse(birthdayStr, "yyyy-MM-dd", utc())
      today = now().utc

    if birthdayDate.month == today.month and birthdayDate.day == today.day:
      sendBirthdayEmail(fullName, email)

proc readCsvAndProcess(filename: string) =
  let lines = readFile(filename).splitLines()
  for i, line in lines.pairs():
    if i > 0: # Assuming the first line is headers
      let fields = line.split(',')
      if fields.len >= 3:
        var row = initTable[string, string]()
        row["Fullname"] = fields[0].strip()
        row["Email"] = fields[1].strip()
        row["Birthday"] = fields[2].strip()
        processRow(row)

when isMainModule:
  let csvFilePath = "test.csv"
  readCsvAndProcess(csvFilePath)
