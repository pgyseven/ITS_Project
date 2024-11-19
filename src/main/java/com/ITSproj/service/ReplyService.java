package com.ITSproj.service;

import java.util.List;

import com.ITSproj.model.ReplyDTO;
import com.ITSproj.model.ReplyVO;

public interface ReplyService {

	List<ReplyVO> getReply(int boardNo) throws Exception;

	boolean insertReply(ReplyDTO replyDTO) throws Exception;

	boolean updateReply(ReplyDTO replyDTO) throws Exception;

	boolean removeReply(int replyNo) throws Exception;

}
