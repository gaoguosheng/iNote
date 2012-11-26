package com.ykesoft.service;

import com.ggs.comm.Config;

public class MsgClient {

	public static int sendMsg(String phone,String msg){
		GSMServiceDelegate delegate = new GSMService().getGSMServicePort();
		return delegate.sendMsg(phone, msg+ Config.SOFT_NAME+"平台。");
	}
	
	public static void main(String[] args) {
		sendMsg("18959189975","测试内容！");
	}
}
