package com.ggs.listener;

import com.ggs.comm.Config;
import com.ggs.util.DateUtil;
import com.ggs.util.SQLiteUtil;
import com.ggs.util.mail.AjavaSendMail;


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
@WebListener
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

                //每周自动发送周工作总结提醒
                String fday=DateUtil.getCurrWeekDay(Config.WEEK_SUMM_DAY)+" "+Config.WEEK_SUMM_TIME;
                if(fday.equals(datetime)){
                    for(Map<String,String> user:userList){
                        String realname=user.get("realname");
                        String qq =user.get("qq");
                        String mobile=user.get("mobile");
                        String to=qq+"@qq.com";
                        String title=realname+"，"+Config.SOFT_NAME+"提醒您撰写本周工作总结";
                        StringBuilder content = new StringBuilder();
                        content.append("请撰写本周（"+DateUtil.getCurrWeekDays()+"）工作总结，如已撰写，请忽略此提醒。<br/>");
                        //发送邮件
                        sendMail(to,title,content.toString(),filename);
                    }
                }
                //有相关新进程开始
                if(DateUtil.getDate("HH:mm").equals(Config.TASK_TIME)){
                    for(Map<String,String>user:userList){
                        String realname=user.get("realname");
                        String userid=user.get("id");
                        String qq = user.get("qq");
                        StringBuilder content = new StringBuilder();
                        StringBuilder sql = new StringBuilder();
                        sql.append(" select a.*,1 ptype from t_progress a where userid="+userid+" and startdate='"+date+"'");
                        sql.append(" union");
                        sql.append(" select a.*,2 ptype from t_progress a where userid="+userid+" and enddate='"+date+"'");
                        sql.append(" union");
                        sql.append(" select a.*,3 ptype from t_progress a where userid="+userid+" and realdate='' and enddate<'"+date+"'");
                        List<Map<String,String>> taskList = sqLiteUtil.queryForList(sql.toString());
                        StringBuilder startTaskHtml=new StringBuilder();
                        StringBuilder endTaskHtml=new StringBuilder();
                        StringBuilder delayTaskHtml=new StringBuilder();
                        for(Map<String,String>task:taskList){
                            String cname = task.get("cname");
                            String startdate=task.get("startdate");
                            String enddate=task.get("enddate");
                            String ptype=task.get("ptype");
                            String cont =cname+" 计划起始日期:"+startdate+" 计划结束日期:"+enddate+"<br/>";
                            if(ptype.equals("1")){
                                //新任务
                                startTaskHtml.append(cont);
                            }else if(ptype.equals("2")){
                                //本日需完成的任务
                                endTaskHtml.append(cont);
                            }else if(ptype.equals("3")){
                                //超时任务
                                delayTaskHtml.append(cont);
                            }
                        }
                        if(taskList.size()>0){
                            String title=realname+"，"+Config.SOFT_NAME+"提醒您今天工作任务";
                            String to = qq+"@qq.com";
                            if(startTaskHtml.length()>0){
                                content.append("<b>本日新任务：</b><br/>");
                                content.append(startTaskHtml);
                            }
                            if(endTaskHtml.length()>0){
                                content.append("<b>本日完成的任务：</b><br/>");
                                content.append(endTaskHtml);
                            }
                            if(delayTaskHtml.length()>0){
                                content.append("<b><font color='red'>加紧完成的超时任务：</font></b><br/>");
                                content.append(delayTaskHtml);
                            }
                            //发送邮件
                            sendMail(to,title,content.toString(),filename);
                        }


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




}
