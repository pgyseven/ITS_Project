package com.ITSproj.persistence;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.ITSproj.model.ReplyDTO;
import com.ITSproj.model.ReplyVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReplyDAOImpl implements ReplyDAO {
	
	private final SqlSession ses;
	private static final String NS = "com.ITSproj.mappers.replyMapper";
	
	@Override
	public List<ReplyVO> getReplyList(int boardNo) throws Exception {
		System.out.println("ReplyDAOImpl : " + boardNo + "번 글의 댓글을 가져오자.");
		
		return ses.selectList(NS + ".getReplyListAboutBoardNo", boardNo);
	}

	@Override
	public int insertReply(ReplyDTO replyDTO) throws Exception {
		
		return ses.insert(NS + ".insertReply", replyDTO);
	}

	@Override
	public int updateReply(ReplyDTO replyDTO) throws Exception {
		
		return ses.update(NS + ".updateReply", replyDTO);
	}

	@Override
	public int removeReplyWithReplyNo(int replyNo) throws Exception {
		
		return ses.delete(NS + ".removeReply", replyNo);
	}

}
