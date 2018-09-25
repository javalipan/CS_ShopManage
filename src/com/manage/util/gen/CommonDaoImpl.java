package com.manage.util.gen;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

/**
 * 数据持久操作实现
 * 
 * @author 张强 2013年9月16日 14时13分
 * 
 */
@Repository
public class CommonDaoImpl implements ICommonDao {
	public final static String OR_JOIN_STRING = "or";
	public final static String AND_JOIN_STRING = "and";
	public final static String DESC = "desc";
	public final static String ASC = "asc";
	public final static String PRIMARY_KEY = "pk";
	public final static String UPDATE_PRIMARY_KEY = "updatepk";

	// springJDBC注入
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}


	public List<Map<String, Object>> selectList(String sql, List<Object> params) throws Exception {
		if (params==null) {
			params = new ArrayList<Object>();
		}
		List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql, params.toArray());
		return queryForList;
	}
}
