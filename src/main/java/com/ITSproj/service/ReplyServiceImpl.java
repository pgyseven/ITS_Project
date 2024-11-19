package com.ITSproj.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ITSproj.model.ReplyDTO;
import com.ITSproj.model.ReplyVO;
import com.ITSproj.persistence.ReplyDAO;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Autowired
	private ReplyDAO rDao;
	
	@Override
	public List<ReplyVO> getReply(int boardNo) throws Exception {
		System.out.println(boardNo + "번 글에 달린 댓글 가져오자.");
		
		List<ReplyVO> list = rDao.getReplyList(boardNo);
		
		return list;
	}

	@Override
	public boolean insertReply(ReplyDTO replyDTO) throws Exception {
		
		boolean result = false;
		
		if(rDao.insertReply(replyDTO) == 1) {
			result = true;
		} else {
			result = false;
		}
		
		return result;
	}

	@Override
	public boolean updateReply(ReplyDTO replyDTO) throws Exception {
		
		boolean result = false;
		
		if(rDao.updateReply(replyDTO) == 1) {
			result = true;
		} else {
			result = false;
		}
		return result;
	}

	@Override
	public boolean removeReply(int replyNo) throws Exception {
		
		boolean result = false;
		
		if(rDao.removeReplyWithReplyNo(replyNo) == 1) {
			result = true;
		} else {
			result = false;
		}
		return result;
	}

}
