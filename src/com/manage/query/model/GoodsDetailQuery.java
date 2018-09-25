package com.manage.query.model;

import com.manage.dao.model.GoodsDetail;
import com.manage.util.Pager;

public class GoodsDetailQuery extends GoodsDetail{

	private static final long serialVersionUID = 1L;
	
	private String colorName;
	private String sizeName;
	private String goodsName;
	
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

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public String getColorName() {
		return colorName;
	}

	public void setColorName(String colorName) {
		this.colorName = colorName;
	}

	public String getSizeName() {
		return sizeName;
	}

	public void setSizeName(String sizeName) {
		this.sizeName = sizeName;
	}

}
