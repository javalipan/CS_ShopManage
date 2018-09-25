package com.manage.query.model;

import java.util.List;

import net.sf.json.JSONObject;


public class TreeNode {

	private String id;
	private String name;
	private String parentid;
	private String state;
	private String checked;
	private List<TreeNode> children;
	private JSONObject attributes;

	public final String getId() {
		return id;
	}

	public final void setId(String id) {
		this.id = id;
	}

	public final String getName() {
		return name;
	}

	public final void setName(String name) {
		this.name = name;
	}

	public final String getParentid() {
		return parentid;
	}

	public final void setParentid(String parentid) {
		this.parentid = parentid;
	}

	public final String getState() {
		return state;
	}

	public final void setState(String state) {
		this.state = state;
	}

	public final String getChecked() {
		return checked;
	}

	public final void setChecked(String checked) {
		this.checked = checked;
	}

	public final List<TreeNode> getChildren() {
		return children;
	}

	public final void setChildren(List<TreeNode> children) {
		this.children = children;
	}

	public final JSONObject getAttributes() {
		return attributes;
	}

	public final void setAttributes(JSONObject attributes) {
		this.attributes = attributes;
	}

}
