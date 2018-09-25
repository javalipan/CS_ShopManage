package com.manage.util.gen;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;


/**
 * 数据持久操作接口,基于spring jdbc
 * 
 * @author 张强 2014年6月16日
 */
@Repository
public interface ICommonDao {
	
	/**
	 * 查询数据 多条数据,为listmap
	 * 
	 * @param sql 完整SQL
	 * @param params 对应的参数列表
	 * @return 返回一个List对象,一个对象为一个MAP,对应一个实体
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList(String sql, List<Object> params) throws Exception;
}
