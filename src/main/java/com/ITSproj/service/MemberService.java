package com.ITSproj.service;

import org.springframework.stereotype.Service;

import com.ITSproj.model.MemberVO;

@Service
public interface MemberService {
	MemberVO loginMember(String userId, String userPwd) throws Exception;
}
