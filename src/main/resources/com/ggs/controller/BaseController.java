package com.ggs.controller;

import com.ggs.model.UserModel;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-10-17
 * Time: 下午2:16
 * To change this template use File | Settings | File Templates.
 */
public abstract class BaseController{


    protected Gson getGson(){
        return new GsonBuilder().create();
    }
    protected String toJson(Object o){
        return this.getGson().toJson(o);
    }

}
