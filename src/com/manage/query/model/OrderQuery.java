package com.manage.query.model;

import com.manage.dao.model.Order;
import com.manage.util.Pager;

public class OrderQuery extends Order {

	private static final long serialVersionUID = 1L;
	
	private String membernickname;
	private String modifyUserName;
	
	private String ordertimestart;
	private String ordertimeend;
	
	private String memberlevel;
	private String brandid;
	private String goodsName;
	private int amount;
	
	private Long goodsid;

	private Pager pager;
	private String orderBy;

	public Pager getPager() {
		return pager;
	}

	public void setPager(Pager pager) {
		this.pager = pager;
	}

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

	public String getMembernickname() {
		return membernickname;
	}

	public void setMembernickname(String membernickname) {
		this.membernickname = membernickname;
	}

	public String getModifyUserName() {
		return modifyUserName;
	}

	public void setModifyUserName(String modifyUserName) {
		this.modifyUserName = modifyUserName;
	}

	public String getOrdertimestart() {
		return ordertimestart;
	}

	public void setOrdertimestart(String ordertimestart) {
		this.ordertimestart = ordertimestart;
	}

	public String getOrdertimeend() {
		return ordertimeend;
	}

	public void setOrdertimeend(String ordertimeend) {
		this.ordertimeend = ordertimeend;
	}

	public String getMemberlevel() {
		return memberlevel;
	}

	public void setMemberlevel(String memberlevel) {
		this.memberlevel = memberlevel;
	}

	public String getBrandid() {
		return brandid;
	}

	public void setBrandid(String brandid) {
		this.brandid = brandid;
	}

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public Long getGoodsid() {
		return goodsid;
	}

	public void setGoodsid(Long goodsid) {
		this.goodsid = goodsid;
	}
	
}
