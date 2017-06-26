//
//  SocketIOManager.swift
//  Workaa
//
//  Created by IN1947 on 1/31/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject
{
    static let sharedInstance = SocketIOManager()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: kChatBaseURL)! as URL)
    var commonmethodClass = CommonMethodClass()

    override init()
    {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SocketIOManager.SocketConnected), name: NSNotification.Name(rawValue: "SocketConnected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SocketIOManager.SocketDisconnected), name: NSNotification.Name(rawValue: "SocketDisconnected"), object: nil)
    }
    
    func establishConnection()
    {
        socket.connect()
    }
    
    func closeConnection()
    {
        socket.disconnect()
    }
    
    func SocketConnected()
    {
        print("SocketConnected")
        if !commonmethodClass.retrieveteamid().isEqual(to: "")
        {
            self.VerifySocket() { (messageInfo) -> Void in
                print("Send messageInfo =>\(messageInfo)")
            }
        }
    }
    
    func SocketDisconnected()
    {
        print("********SocketDisconnected*******")
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func groupResetCount(groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken()] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        socket.emitWithAck("GroupMessageUnread", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func cafeResetCount(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken()] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        socket.emitWithAck("CafeMessageUnread", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func directResetCount(uid: String, completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "uid":uid] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        socket.emitWithAck("DirectMessageUnread", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func groupRemoveFav(idstring: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "id": idstring] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupMessageRemoveStarred", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func directRemoveFav(idstring: String, uid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["uid": uid, "token": commonmethodClass.retrieveUsernameToken(), "id": idstring] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectMessageRemoveStarred", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func cafeRemoveFav(idstring: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "id": idstring] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeMessageRemoveStarred", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func editImagetitlecap(groupid: String, title: String, caption: String, idString: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "title": title, "caption": caption, "id" : idString] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupMessageImageEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func directeditImagetitlecap(uid: String, title: String, caption: String, idString: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["uid": uid, "token": commonmethodClass.retrieveUsernameToken(), "title": title, "caption": caption, "id" : idString] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectImageEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func CafeeditImagetitlecap(title: String, caption: String, idString: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "title": title, "caption": caption, "id" : idString] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeImageEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func sendMessage(message: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        print("*** sendMessage =>\(message)");
        
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "message": message] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupMessage", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func sendCafeMessage(message: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        print("*** sendMessage =>\(message)");
        
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "message": message] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeMessage", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func sendOneToOneMessage(message: String, userid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        print("*** sendMessage =>\(message)");
        
        let messagedictionary = ["uid": userid, "token": commonmethodClass.retrieveUsernameToken(), "message": message] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectMessage", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func editMessage(message: String, msgId: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        print("*** editMessage =>\(message)");
        
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "message": message, "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupMessageEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func starMessage(msgId: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupMessageStarred", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func directstarMessage(msgId: String, uid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["uid": uid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectMessageStarred", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func cafestarMessage(msgId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeMessageStarred", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func editCafeMessage(message: String, msgId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        print("*** editMessage =>\(message)");
        
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "message": message, "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeMessageEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func oneTooneeditMessage(message: String, msgId: String, userid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        print("*** editMessage =>\(message)");
        
        let messagedictionary = ["uid": userid, "token": commonmethodClass.retrieveUsernameToken(), "message": message, "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectMessageEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func commenteditMessage(message: String, cmtId: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "comment": message, "id": cmtId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupCommentEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func commentCafeeditMessage(message: String, cmtId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "comment": message, "id": cmtId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeCommentEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func commentOneToOneeditMessage(message: String, cmtId: String, userid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["uid": userid, "token": commonmethodClass.retrieveUsernameToken(), "comment": message, "id": cmtId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectCommentEdit", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func deleteMessage(msgId: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupMessageDelete", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func deleteCafeMessage(msgId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeMessageDelete", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func oneToonedeleteMessage(msgId: String, userid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["uid": userid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectMessageDelete", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func shareMessage(message: String, msgId: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgId, "message": message] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupShareMessage", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func shareCafeMessage(message: String, msgId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "id": msgId, "message": message] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeShare", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func shareOneToOneMessage(message: String, msgId: String, userid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["uid": userid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgId, "message": message] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectShare", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func commentdeleteMessage(groupid: String, cmtId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "id": cmtId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("GroupCommentDelete", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func commentCafedeleteMessage(cmtId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["token": commonmethodClass.retrieveUsernameToken(), "id": cmtId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("CafeCommentDelete", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = data[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func commentOneToOnedeleteMessage(userid: String, cmtId: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["uid": userid, "token": commonmethodClass.retrieveUsernameToken(), "id": cmtId] as [String : Any]
        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("DirectCommentDelete", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func sendComment(msgid: String, comment: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let commentdictionary = ["gid": groupid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgid, "comment": comment] as [String : Any]
        print("commentdictionary =>\(commentdictionary)");
        
        socket.emitWithAck("GroupMessageComment", commentdictionary)(0) {data in
            print("got ack =>\(data)")
            var commentDictionary : NSDictionary!
            commentDictionary = data[0] as! NSDictionary
            completionHandler(commentDictionary)
        }
    }
    
    func sendCafeComment(msgid: String, comment: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let commentdictionary = ["token": commonmethodClass.retrieveUsernameToken(), "id": msgid, "comment": comment] as [String : Any]
        print("commentdictionary =>\(commentdictionary)");
        
        socket.emitWithAck("CafeComment", commentdictionary)(0) {data in
            print("got ack =>\(data)")
            if(data.count>0)
            {
                var commentDictionary : NSDictionary!
                commentDictionary = data[0] as! NSDictionary
                completionHandler(commentDictionary)
            }
        }
    }
    
    func sendOneToOneComment(msgid: String, comment: String, userid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let commentdictionary = ["uid": userid, "token": commonmethodClass.retrieveUsernameToken(), "id": msgid, "comment": comment] as [String : Any]
        print("commentdictionary =>\(commentdictionary)");
        
        socket.emitWithAck("DirectComment", commentdictionary)(0) {data in
            print("got ack =>\(data)")
            var commentDictionary : NSDictionary!
            commentDictionary = data[0] as! NSDictionary
            completionHandler(commentDictionary)
        }
    }
    
    func sendFile(txtfile: String, groupid: String,  completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let messagedictionary = ["groupid": groupid, "userid": commonmethodClass.retrieveuserid(), "teamid": commonmethodClass.retrieveteamid(), "sessid": commonmethodClass.retrievesessionid(), "image": txtfile] as [String : Any]
//        print("messagedictionary =>\(messagedictionary)");
        
        socket.emitWithAck("InsertImageGroupChat", messagedictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func VerifySocket(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void)
    {
        let verifydictionary = ["token": commonmethodClass.retrieveUsernameToken()] as [String : Any]
        print("verifydictionary =>\(verifydictionary)");
        
        socket.emitWithAck("VerifySocket", verifydictionary)(0) {data in
            print("got ack =>\(data)")
            var messageDictionary : NSDictionary!
            messageDictionary = data[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getNotificationMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("Notification") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupMsg") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getCafeChatMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeMessage") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getOneToOneChatMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectMessage") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getEditMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupMsgEdit") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCafeEditMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeMessageEdit") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getOneToOneEditMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectMessageEdit") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCommentEditMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupCmtEdit") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCommentCafeEditMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeCommentEdit") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getCommentOneToOneEditMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectCommentEdit") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCommentDeleteMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupCmtDel") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCommentCafeDeleteMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeCommentDelete") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getOneToOneCommentDeleteMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectCommentDelete") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getDeleteMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupMsgDel") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCafeDeleteMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeMessageDelete") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getOneToOneDeleteMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectMessageDelete") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getShareMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupShareMsg") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCafeShareMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeShare") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getOneToOneShareMessage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectShare") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getChatImage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupMsgImg") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCafeChatImage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeImage") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getOneToOneChatImage(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectImage") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getChatComment(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupMsgComt") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getCafeChatComment(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeComment") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getOneToOneChatComment(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectComment") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func getGroupUrlPreview(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("GroupUrlPreview") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func getChatTyping(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupMessageTyping") { (dataArray, socketAck) -> Void in
            
            print("dataArray =>\(dataArray)")
            
            var messageDictionary : NSDictionary!
            messageDictionary = dataArray[0] as! NSDictionary
            completionHandler(messageDictionary)
        }
    }
    
    func groupMsgImgEdit(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("SendGroupMsgImgEdit") { (dataArray, socketAck) -> Void in
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func directMsgImgEdit(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("DirectImageEdit") { (dataArray, socketAck) -> Void in
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    func cafeMsgImgEdit(completionHandler: @escaping (_ messageInfo: NSDictionary) -> Void) {
        socket.on("CafeImageEdit") { (dataArray, socketAck) -> Void in
            print("dataArray =>\(dataArray)")
            if(dataArray.count>0)
            {
                var messageDictionary : NSDictionary!
                messageDictionary = dataArray[0] as! NSDictionary
                completionHandler(messageDictionary)
            }
        }
    }
    
    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    
    func sendStartTypingMessage(groupid: String, typing: String)
    {
        let typingdictionary = ["groupid": groupid, "userid": commonmethodClass.retrieveuserid(), "teamid": commonmethodClass.retrieveteamid(), "sessid": commonmethodClass.retrievesessionid(), "typing": typing] as [String : Any]
        print("typingdictionary =>\(typingdictionary)");
        
        socket.emitWithAck("GroupMessageTyping", typingdictionary)(0) {data in
            print("got ack =>\(data)")
//            var messageDictionary : NSDictionary!
//            messageDictionary = data[0] as! NSDictionary
//            completionHandler(messageDictionary)
        }
    }
    
    func sendStopTypingMessage(groupid: String, typing: String)
    {
        let typingdictionary = ["groupid": groupid, "userid": commonmethodClass.retrieveuserid(), "teamid": commonmethodClass.retrieveteamid(), "sessid": commonmethodClass.retrievesessionid(), "typing": typing] as [String : Any]
        print("typingdictionary =>\(typingdictionary)");
        
        socket.emitWithAck("GroupMessageTyping", typingdictionary)(0) {data in
            print("got ack =>\(data)")
            //            var messageDictionary : NSDictionary!
            //            messageDictionary = data[0] as! NSDictionary
            //            completionHandler(messageDictionary)
        }
    }
}
