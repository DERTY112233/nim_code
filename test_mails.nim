import net 
import smtp 
import os 
import strutils
import strformat

var Fullname = paramStr(1)
var emailperson = paramStr(2)
var username = "joelpaiva112233@gmail.com"
var password = "ikxrbmwqzcneteiw"


proc sendBirthdayEmail(fullname, email: string) =
    echo "testssssss" 
    echo fmt"[+]Sending email to {emailperson} ."
    var msg = createMessage("Dear test person" ,
                            "test.\n test",
                            @["joelpaiva112233@gmail.com"])
    let smtpConn = newSmtp(useSsl=true,   debug=true)
    smtpConn.connect("smtp.gmail.com", Port 465)
    smtpConn.auth(username, password)
    smtpConn.sendmail(emailperson, @[fmt"{emailperson}"], $msg)


sendBirthdayEmail(Fullname, emailperson)