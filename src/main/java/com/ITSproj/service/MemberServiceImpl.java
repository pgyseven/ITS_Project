package com.ITSproj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ITSproj.model.MemberVO;
import com.ITSproj.persistence.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {
	@Autowired
	private MemberDAO dao;
	
	@Override
	public MemberVO loginMember(String userId, String userPwd) throws Exception {
		
		return dao.getMember(userId,userPwd);
	}

}
