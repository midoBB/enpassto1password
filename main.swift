//
//  main.swift
//  enpasstocsv
//
//  Created by Mohamed Haamdi on 22/06/16.
//

import Foundation
class Login{
    var Title : String?
    var Username : String?
    var Password : String?
    var URL : String?
}
var LoginArray = [Login]()
var tempLogin = Login()
var isLastLine = false
var output = ""
func clearPrefix(line : String,prefix : String)->String{
    var copy = line
    copy.removeRange(copy.rangeOfString(prefix)!)
    copy = copy.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    return copy
}
func treatLine(line : String){
    if(line.hasPrefix("Title")){
        if tempLogin.Title != nil{
            LoginArray.append(tempLogin)
            tempLogin = Login()
        }
        tempLogin.Title = clearPrefix(line, prefix: "Title : ")
    }
    else if(line.hasPrefix("Login")){
        tempLogin.Username = clearPrefix(line, prefix: "Login : ")
    }
    else if(line.hasPrefix("Email")){
        tempLogin.Username = clearPrefix(line, prefix: "Email : ")
    }
    else if(line.hasPrefix("Username")){
        tempLogin.Username = clearPrefix(line, prefix: "Username : ")
    }
    else if(line.hasPrefix("Password")){
        tempLogin.Password = clearPrefix(line, prefix: "Password : ")
    }
    else if(line.hasPrefix("Url")){
        tempLogin.URL = clearPrefix(line, prefix: "Url : ")
    }
    if isLastLine {
        LoginArray.append(tempLogin)
    }
}
let filename = Process.arguments[1]
let file: NSFileHandle? = NSFileHandle(forReadingAtPath: filename)
if file != nil{
    let data = file?.readDataToEndOfFile()
    file?.closeFile()
    let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
    let string  = String(str!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    for substring in string.componentsSeparatedByString("\n"){
        if string.hasSuffix(substring){
            isLastLine = true
        }
        treatLine(substring)
    }
    
    for login in LoginArray{
        output += "\(login.Title ?? ""),\(login.URL ?? ""),\(login.Username ?? ""),\(login.Password ?? ""),,\n"
        
    }
    let path = filename.componentsSeparatedByString(".")[0]+".csv"
    do {
        try output.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
    }
    print("Successfully added \(LoginArray.count) items to the new CSV file.")
}
else {
    print("You need to provide a valid Enpass file as an argument to the program.")
}