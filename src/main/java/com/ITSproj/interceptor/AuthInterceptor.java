package com.ITSproj.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ITSproj.model.BoardVO;
import com.ITSproj.model.MemberVO;
import com.ITSproj.model.ReplyVO;
import com.ITSproj.service.BoardService;
import com.ITSproj.service.ReplyService;


public class AuthInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private BoardService bService;
	
	@Autowired
	private ReplyService rService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("authPreHandle");
		boolean goController = false; 
		
		
		new DestiationPath().setDestPath(request);  
		
		HttpSession sess = request.getSession();
		
		if(sess.getAttribute("loginMember")==null) {  
			response.sendRedirect("/loginPage");
		}else {  
			
			System.out.println("[AuthInterceptor] : 로그인 OK 되어있다.![그 글에 대한 수정/삭제 권한(본인글)이 있는지 검사]");
			
			goController = true;
			
			
			// 만약 글(답글)수정, 글(답글) 삭제의 페이지에서 왔다면 그 글에 대한 수정/삭제 권한(본인글)이 있는지?
			String uri = request.getRequestURI();
			
			// 로그인한 유저의 정보
			MemberVO loginMember = (MemberVO) sess.getAttribute("loginMember");
		}
		
		
		return goController;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
	}


	

	
}
