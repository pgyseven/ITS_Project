package com.ITSproj.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ITSproj.model.RoadReplyDTO;
import com.ITSproj.model.RoadReplyVO;
import com.ITSproj.persistence.RoadReplyDAO;

@Service
public class RoadReplyServiceImpl implements RoadReplyService {
	
	@Autowired
	private RoadReplyDAO roadDAO;

	@Override
	public List<RoadReplyVO> getRoadRepliesByUnitCode(String unitCode) throws Exception {
		
		System.out.println("RoadReplyServiceImpl - 유저가 조회한 unitCode : " + unitCode);
		
		return roadDAO.getRoadReply(unitCode);
	}

	@Override
	public boolean insertReply(RoadReplyDTO roadDTO) throws Exception {
		boolean result = false;
		
		if (roadDAO.insertReply(roadDTO) == 1) {
			result = true;
		} else {
			result = false;
		}
		return result;
	}

	@Override
	public boolean removeRoadReply(int roadReplyNo) throws Exception {
		boolean result = false;
		
		if(roadDAO.removeRoadReply(roadReplyNo) == 1) {
			result = true;
		} else {
			result = false;
		}
		
		return result;
	}

}
