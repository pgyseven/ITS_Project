package com.ITSproj.service;


import java.util.List;
import java.util.Map;

import com.ITSproj.model.BoardDTO;
import com.ITSproj.model.BoardVO;
import com.ITSproj.model.PagingInfoDTO;

public interface BoardService {

	Map<String, Object> getAllBoard(PagingInfoDTO dto) throws Exception;

	public boolean modifyBoard(BoardDTO modifyBoard) throws Exception;

	public BoardVO read(int boardNo) throws Exception;

	public BoardVO read(int boardNo, String ipAddr) throws Exception;

	boolean removeBoard(int boardNo) throws Exception;

	boolean saveBoard(BoardDTO newBoard) throws Exception;

	List<BoardVO> getPopularBoards() throws Exception;

}
