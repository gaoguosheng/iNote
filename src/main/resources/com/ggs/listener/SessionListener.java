package com.ggs.listener;

import com.ggs.dao.NoteDao;
import com.ggs.model.UserModel;

import javax.servlet.ServletContext;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-7-25
 * Time: 下午4:11
 * To change this template use File | Settings | File Templates.
 */
@WebListener
public class SessionListener implements HttpSessionListener {

    private NoteDao noteDao = new NoteDao();

    @Override
    public void sessionCreated(HttpSessionEvent httpSessionEvent) {

    }

    @Override
    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
        ServletContext context =session.getServletContext();
        if(context.getAttribute("onlineList")!=null){
            Set<String> set = (Set) context.getAttribute("onlineList");
            UserModel model = (UserModel)session.getAttribute("adminModel");
            set.remove(model.getRealname());
        }
        //更新在线时间
        long times =session.getLastAccessedTime()-  session.getCreationTime();
        this.noteDao.updateOnlinetimes(((UserModel)session.getAttribute("adminModel")).getUserid(),times/1000/60);

    }
}
