package com.ggs.comm;

import org.omg.CORBA.PUBLIC_MEMBER;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-5-28
 * Time: 下午2:09
 * To change this template use File | Settings | File Templates.
 */
public class Config {
    public static String COPY="" ;
    public static String SOFT_NAME="iNote";
    public static String DB_PATH="";
    //周总结提醒
    public static int WEEK_SUMM_DAY=0;
    public static String WEEK_SUMM_TIME="";
    //任务提醒
    public static String TASK_TIME="";



    //超级管理员
    public final static String SUPER_ADMIN="ggs";
    //首页
    public final static String INDEX_PAGE="index.jsp";
    //后缀
    public final static String EXT=".ggs";


    static{
        Properties p = new Properties();
        try {
            p.load(Config.class.getResourceAsStream("/conf.properties"));
            DB_PATH= p.getProperty("DB_PATH");
            WEEK_SUMM_DAY=Integer.parseInt(p.getProperty("WEEK_SUMM_DAY")) ;
            WEEK_SUMM_TIME=p.getProperty("WEEK_SUMM_TIME");
            TASK_TIME=p.getProperty("TASK_TIME");



        } catch (IOException e) {
            e.printStackTrace();
        }
        COPY="Copyright © 2002 - "+new SimpleDateFormat("yyyy").format(new Date())+" GGS. All Rights Reserved";

    }
}
