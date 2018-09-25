package com.manage.query.mapper;

import java.util.List;

import com.manage.query.model.GoodsBrowseHisQuery;

public interface GoodsBrowseHisQueryMapper {

	public List<GoodsBrowseHisQuery> sumBrowseHistory(GoodsBrowseHisQuery goodsBrowseHisQuery);
	
	/** 
	*  根据条件查询列表
	* @param goodsBrowseHisQuery
	* @return List<GoodsBrowseHisQuery>     
	*/
	public List<GoodsBrowseHisQuery> selectByGoodsBrowseHisQuery(GoodsBrowseHisQuery goodsBrowseHisQuery);
	/** 
	*  查询条数
	* @param goodsBrowseHisQuery
	* @return Integer     
	*/
	public Integer countByGoodsBrowseHisQuery(GoodsBrowseHisQuery goodsBrowseHisQuery);
	
}
