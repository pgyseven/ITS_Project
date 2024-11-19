package com.ITSproj.persistence;

import org.springframework.stereotype.Repository;

import com.ITSproj.model.MemberVO;

@Repository
public interface MemberDAO {

	public MemberVO getMember(String userId, String userPwd) throws Exception;
}
