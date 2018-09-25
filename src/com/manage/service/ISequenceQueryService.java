package com.manage.service;


public interface ISequenceQueryService {

	
	/** 
	*根据序列名称获取序列值
	* @param sequenceName	: 序列名称
	* @return    Integer
	* @author lipan@cqrainbowsoft.com    
	*/
	public Long getSeqNextVal(String sequenceName);
}
