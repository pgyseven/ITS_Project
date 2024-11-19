package com.ITSproj.persistence;

import java.util.List;

import com.ITSproj.model.ReplyDTO;
import com.ITSproj.model.ReplyVO;

public interface ReplyDAO {

	List<ReplyVO> getReplyList(int boardNo) throws Exception;

	int insertReply(ReplyDTO replyDTO) throws Exception;

	int updateReply(ReplyDTO replyDTO) throws Exception;

	int removeReplyWithReplyNo(int replyNo) throws Exception;

}
