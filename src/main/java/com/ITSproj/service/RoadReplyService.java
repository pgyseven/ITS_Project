package com.ITSproj.service;

import java.util.List;

import com.ITSproj.model.RoadReplyDTO;
import com.ITSproj.model.RoadReplyVO;

public interface RoadReplyService {

	List<RoadReplyVO> getRoadRepliesByUnitCode(String unitCode) throws Exception;

	boolean insertReply(RoadReplyDTO roadDTO) throws Exception;

	boolean removeRoadReply(int roadReplyNo) throws Exception;

}
