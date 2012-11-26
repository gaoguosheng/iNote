package com.ggs.listener;

import com.ggs.comm.Config;
import com.ggs.util.DateUtil;
import com.ggs.util.SQLiteUtil;
import com.ggs.util.mail.AjavaSendMail;
import com.ykesoft.service.MsgClient;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.*;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-10-25
 * Time: 上午10:00
 * To change this template use File | Settings | File Templates.
 */
//@WebListener
public class ContextListener implements ServletContextListener {
    private SQLiteUtil sqLiteUtil = new SQLiteUtil();
    private Timer timer  =null;

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        final  String filename = servletContextEvent.getServletContext().getRealPath("images/logo.jpg");
        final List<Map<String,String>> userList =  sqLiteUtil.queryForList("select * from t_user");
        timer=new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                //获取当前日期
                String date = DateUtil.getDate("yyyy-MM-dd");
                String datetime=DateUtil.getDate("yyyy-MM-dd HH:mm");
                //获取当前日期下有无相关进程列表
                List<Map<String,String>> taskStartList = sqLiteUtil.queryForList("select DISTINCT a.userid,b.realname,b.qq,b.mobile from t_progress a left join t_user b on a.userid=b.id where startdate='"+date+"'");
                //获取当前日期下有无相关进程列表
                List<Map<String,String>> taskEndList = sqLiteUtil.queryForList("select DISTINCT a.userid,b.realname,b.qq,b.mobile from t_progress a left join t_user b on a.userid=b.id where enddate='"+date+"'");

                //每周自动发送周工作总结提醒
                String fday=DateUtil.getCurrWeekDay(Config.WEEK_SUMM_DAY)+" "+Config.WEEK_SUMM_TIME;
                if(fday.equals(datetime)){


                    for(Map<String,String> user:userList){
                        String realname=user.get("realname");
                        String qq =user.get("qq");
                        String mobile=user.get("mobile");
                        String to=qq+"@qq.com";
                        String title=realname+"，您还未撰写本周工作总结";
                        StringBuilder content = new StringBuilder();
                        content.append("请撰写本周（"+DateUtil.getCurrWeekDays()+"）工作总结，如已撰写，请忽略此提醒。<br/>");
                        //发送邮件
                        sendMail(to,title,content.toString(),filename);
                    }
                }
                //有相关新进程开始
                if(taskStartList.size()>0 && DateUtil.getDate("HH:mm").equals(Config.TASK_TIME)){
                    for(Map<String,String>user:taskStartList){
                        String realname=user.get("realname");
                        String userid=user.get("userid");
                        String qq = user.get("qq");
                        StringBuilder content = new StringBuilder();
                        content.append("今天您的新任务列表如下:<br/>");
                        List<Map<String,String>> taskList = sqLiteUtil.queryForList("select * from t_progress where userid="+userid+" and startdate='"+date+"'");
                        for(Map<String,String>task:taskList){
                            String cname = task.get("cname");
                            String startdate=task.get("startdate");
                            String enddate=task.get("enddate");
                            content.append(cname+" 计划起始日期:"+startdate+" 计划结束日期:"+enddate+"<br/>");
                        }
                        String title=realname+"，今天您有新的工作任务";
                        String to = qq+"@qq.com";
                        //发送邮件
                        sendMail(to,title,content.toString(),filename);
                    }
                }

                //有相关新进程结束
                if(taskEndList.size()>0 && DateUtil.getDate("HH:mm").equals(Config.TASK_TIME)){
                    for(Map<String,String>user:taskEndList){
                        String realname=user.get("realname");
                        String userid=user.get("userid");
                        String qq = user.get("qq");
                        StringBuilder content = new StringBuilder();
                        content.append("今天您需要结束的工作列表如下:<br/>");
                        List<Map<String,String>> taskList = sqLiteUtil.queryForList("select * from t_progress where userid="+userid+" and enddate='"+date+"'");
                        for(Map<String,String>task:taskList){
                            String cname = task.get("cname");
                            String startdate=task.get("startdate");
                            String enddate=task.get("enddate");
                            content.append(cname+" 计划起始日期:"+startdate+" 计划结束日期:"+enddate+"<br/>");
                        }
                        String title=realname+"，今天您需要结束的工作任务";
                        String to = qq+"@qq.com";
                        //发送邮件
                        sendMail(to,title,content.toString(),filename);
                    }
                }
            }
        },0,60000);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        timer.cancel();
        timer=null;
    }


    private void sendMail(String to,String title,String text,String filename) {

        String stmp = "smtp.qq.com";
        String from = "gswon@vip.qq.com";// 发信邮箱
        String username = "gswon@vip.qq.com";
        String password = "ggs008";
        String subject = title;// 邮件主题
        AjavaSendMail sm = new AjavaSendMail(stmp);
        sm.setNamePass(username, password);
        sm.setSubject(subject);
        sm.setFrom(from);
        sm.setTo(to);
        sm.setText(text+"<div>本邮件为"+Config.SOFT_NAME+"平台自动发送，无需回复。</div>");
        sm.addFileAffix(filename);
        sm.createMimeMessage();
        sm.setOut();
    }

    /**
     * 获取星期
     * */
    private String getWeek(int n){
        String str="";
        switch ( n )
        {
            case 0:
            str="星期一" ;
            break;
            case 1 :
                str="星期二" ;
                break;
            case 2 :
                str="星期三" ;
                break;
            case 3 :
                str="星期四" ;
                break;
            case 4 :
                str="星期五" ;
                break;
            case 5 :
                str="星期六" ;
                break;
            case 6 :
                str="星期日" ;
                break;
        }

        return str;

    }


}
