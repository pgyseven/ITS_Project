package com.ITSproj.persistence;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ITSproj.model.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	private SqlSession sess;
	
	private String NS = "com.tn.mapper.memberMapper";
	
	public MemberVO getMember(String userId, String userPwd) throws Exception {
		Map<String, String> loginMember = new HashMap<>();
		
		loginMember.put("userId", userId);
		loginMember.put("userPwd", userPwd);
	
		return sess.selectOne(NS+".getLoginMember", loginMember);
	}

}
