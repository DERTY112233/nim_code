import strutils, tables, times, smtp, os, net

# Adjust the imports if necessary. For SSL support, you might need additional imports depending on your setup.

proc sendBirthdayEmail(fullName, email: string) =
  let
    message = "Subject: Happy Birthday!\n\nDear " & fullName & ",\n\nHappy Birthday!\n\nBest wishes,\nYour Organization"
    smtpServer = "smtp.gmail.com"
    smtpPort = 587  # Adjust based on your server's requirements
    senderEmail = "joelpaiva112233@gmail.com"
    senderPassword = "evgffcalurwfspen"  # Consider using a more secure approach for storing passwords
    recipientEmail = email
  
  # Setup the SMTP connection
  var smtpSession = newSmtp(useSsl=true, debug=false, SslContext=nil)
  
  try:
    # Connect and authenticate with the SMTP server
    smtpClient.auth(senderEmail, senderPassword)
    # Send the email
    smtpClient.sendMail(senderEmail, @[recipientEmail], message)
  except SmtpError as e:
    echo "Failed to send email: ", e.msg
  finally:
    # Close the SMTP connection
    smtpClient.quit()

proc processRow(row: Table[string, string]) =
  let
    fullName = row.getOrDefault("Full name", "")
    email = row.getOrDefault("Email", "")
    birthdayStr = row.getOrDefault("Birthday", "")
  
  if fullName != "" and email != "" and birthdayStr != "":
    let
      birthdayDate = parse(birthdayStr, "MM/dd/yyyy", utc())
      today = now().toTimezone(utc()).date
    
    if birthdayDate.month == today.month and birthdayDate.day == today.day:
      sendBirthdayEmail(fullName, email)

proc readCsvAndProcess(filename: string) =
  let lines = readFile(filename).splitLines()

  for i, line in lines:
    if i > 0: # Assuming the first line is headers
      let fields = line.split(',')
      if fields.len >= 3:
        var row = initTable[string, string]()
        row["Full name"] = fields[0].strip()
        row["Email"] = fields[1].strip()
        row["Birthday"] = fields[2].strip()
        processRow(row)

when isMainModule:
  let csvFilePath = "test.csv"
  readCsvAndProcess(csvFilePath)
