package com.ITSproj.persistence;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.ITSproj.model.RoadReplyDTO;
import com.ITSproj.model.RoadReplyVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RoadReplyDAOImpl implements RoadReplyDAO {
	
	private final SqlSession ses;
	private static final String NS = "com.ITSproj.mappers.RoadReplyMapper";
	
	
	@Override
	public List<RoadReplyVO> getRoadReply(String unitCode) throws Exception {
		
		System.out.println("RoadReplyDAOImpl - 유저가 조회한 유닛코드(" + unitCode + ") 지역의 댓글을 가져오자.");
		
		return ses.selectList(NS + ".getRoadRepliesByUnitCode", unitCode);
	}


	@Override
	public int insertReply(RoadReplyDTO roadDTO) throws Exception {
		
		return ses.insert(NS + ".insertReply", roadDTO);
	}


	@Override
	public int removeRoadReply(int roadReplyNo) throws Exception {
		
		return ses.delete(NS + ".removeRoadReply", roadReplyNo);
	}
	
	
}
