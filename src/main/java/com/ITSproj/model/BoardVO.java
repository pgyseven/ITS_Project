package com.ITSproj.model;

import java.sql.Timestamp;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
public class BoardVO {
	private int boardNo;
	private String title;
	private String writer;
	private String content;
	private Timestamp postDate;
	
	private int ref;
	private int readCount;
	private int refOrder;
}
