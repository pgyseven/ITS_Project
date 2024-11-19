package com.ITSproj.interceptor;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ITSproj.model.MemberVO;



public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("preHandle");
		boolean isLoginPageShow = false; 
		if(request.getMethod().toUpperCase().equals("GET")) {
			if(request.getParameter("redirectUri") != null) {
				String redirectUri =(String)request.getParameter("redirectUri");
			}
			if(request.getSession().getAttribute("loginMember") == null) { 					
				isLoginPageShow = true;
			}else {
				isLoginPageShow = false;
			}
		
		}else if(request.getMethod().toUpperCase().equals("POST")){

			isLoginPageShow = true;
		}
		
		
		
		
		return isLoginPageShow;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		System.out.println("postHandle");
		HttpSession sess = request.getSession();
		if(request.getMethod().toUpperCase().equals("POST")) {
			
			MemberVO loginMember =(MemberVO) sess.getAttribute("loginMember");
			
			if(loginMember != null) {
				
				Object tmp = sess.getAttribute("destPath");
				
				System.out.println("tmp: " + (String) tmp);
				
				String viewName = ((tmp != null) ? "/" : (String) sess.getAttribute("destPath"));
				modelAndView.addObject("status", "loginSuccess");
				
//				if(viewName.contains("admin")) {
//					viewName = !loginMember.getUserId().equals("admin") ? "/" : viewName; 
//				}
				
				modelAndView.setViewName("redirect:"+viewName);
				
				System.out.println(modelAndView.getViewName());
			}else if(sess.getAttribute("loginMember") == null) {
				modelAndView.addObject("status", "loginFail");
				modelAndView.setViewName("/loginPage");
			}
		
		
			
		}
		
		
		
		super.postHandle(request, response, handler, modelAndView);
	}

	
}
