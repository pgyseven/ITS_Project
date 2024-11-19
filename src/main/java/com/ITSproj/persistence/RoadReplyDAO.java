package com.ITSproj.persistence;

import java.util.List;

import com.ITSproj.model.RoadReplyDTO;
import com.ITSproj.model.RoadReplyVO;

public interface RoadReplyDAO {

	List<RoadReplyVO> getRoadReply(String unitCode) throws Exception;

	int insertReply(RoadReplyDTO roadDTO) throws Exception;

	int removeRoadReply(int roadReplyNo) throws Exception;


}
