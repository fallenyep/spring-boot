/*
 * Copyright 2012-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.boot.loader;

import java.io.IOException;
import java.net.JarURLConnection;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.URLConnection;
import java.security.AccessController;
import java.security.PrivilegedExceptionAction;
import java.util.Enumeration;
import java.util.jar.JarFile;

import org.springframework.boot.loader.jar.Handler;

/**
 * {@link ClassLoader} used by the {@link Launcher}.
 *
 * @author Phillip Webb
 * @author Dave Syer
 * @author Andy Wilkinson
 * @since 1.0.0
 */
/*LaunchedURLClassLoader 是 spring-boot-loader 项目自定义的类加载器，实现对 jar 包中 META-INF/classes 目录下的类和 META-INF/lib 内嵌的 jar 包中的类的加载*/
public class LaunchedURLClassLoader extends URLClassLoader {

	static {
		ClassLoader.registerAsParallelCapable();
	}

	/**
	 * Create a new {@link LaunchedURLClassLoader} instance.
	 * @param urls the URLs from which to load classes and resources
	 * @param parent the parent class loader for delegation
	 */
	/*第一个参数 urls，使用的是 Archive 集合对应的 URL 地址们，从而告诉 LaunchedURLClassLoader 读取 jar 的地址。
     第二个参数 parent，设置 LaunchedURLClassLoader 的父加载器。这里后续胖友可以理解下，类加载器的双亲委派模型，这里就拓展开了。*/
	public LaunchedURLClassLoader(URL[] urls, ClassLoader parent) {
		super(urls, parent);
	}

	@Override
	public URL findResource(String name) {
		Handler.setUseFastConnectionExceptions(true);
		try {
			return super.findResource(name);
		}
		finally {
			Handler.setUseFastConnectionExceptions(false);
		}
	}

	@Override
	public Enumeration<URL> findResources(String name) throws IOException {
		Handler.setUseFastConnectionExceptions(true);
		try {
			return new UseFastConnectionExceptionsEnumeration(super.findResources(name));
		}
		finally {
			Handler.setUseFastConnectionExceptions(false);
		}
	}

	@Override
	protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
		Handler.setUseFastConnectionExceptions(true);
		try {
			try {
				// 定义类所属的包路径,例如 org.springframework.boot.loader.LaunchedURLClassLoader
				definePackageIfNecessary(name);
			}
			catch (IllegalArgumentException ex) {
				// Tolerate race condition due to being parallel capable
				if (getPackage(name) == null) {
					// This should never happen as the IllegalArgumentException indicates
					// that the package has already been defined and, therefore,
					// getPackage(name) should not return null.
					throw new AssertionError("Package " + name + " has already been defined but it could not be found");
				}
			}
			return super.loadClass(name, resolve);
		}
		finally {
			Handler.setUseFastConnectionExceptions(false);
		}
	}

	/**
	 * Define a package before a {@code findClass} call is made. This is necessary to
	 * ensure that the appropriate manifest for nested JARs is associated with the
	 * package.
	 * 翻译：定义一个包在调用 findClass 方法之前。这是必要的，以确保嵌套 JAR 的适当清单与包相关联。
	 * @param className the class name being found
	 */
	private void definePackageIfNecessary(String className) {
		int lastDot = className.lastIndexOf('.');
		if (lastDot >= 0) {
			// 获取类名中的包名，
			String packageName = className.substring(0, lastDot);
			// 检查包是否已经定义，已定义意味着该包已经被加载器加载过，并且在加载器的命名空间中可见，否则定义该包。
			if (getPackage(packageName) == null) {
				try {
					// 定义包
					definePackage(className, packageName);
				}
				catch (IllegalArgumentException ex) {
					// Tolerate race condition due to being parallel capable
					if (getPackage(packageName) == null) {
						// This should never happen as the IllegalArgumentException
						// indicates that the package has already been defined and,
						// therefore, getPackage(name) should not have returned null.
						throw new AssertionError(
								"Package " + packageName + " has already been defined but it could not be found");
					}
				}
			}
		}
	}

	private void definePackage(String className, String packageName) {
		try {
			// AccessController.doPrivileged 方法用于在特权环境中执行指定的操作。
			// 这里的操作是定义包，需要在特权环境中执行，以确保权限足够。
			AccessController.doPrivileged((PrivilegedExceptionAction<Object>) () -> {
				// 构建包路径和类路径，replace 方法将包名中的点号替换为斜杠，以符合 jar 包的目录结构。例如 org.springframework.boot.loader.LaunchedURLClassLoader 对应的包路径为 org/springframework/boot/loader/
				String packageEntryName = packageName.replace('.', '/') + "/";
				// 类路径，例如 org.springframework.boot.loader.LaunchedURLClassLoader 对应的类路径为 org/springframework/boot/loader/LaunchedURLClassLoader.class
				String classEntryName = className.replace('.', '/') + ".class";
				// 遍历所有 URL，检查是否有 jar 包中包含类和包的入口。getURLs 方法返回所有已添加的 URL。
				// URL是指 jar 包的 URL 地址。例如 file:/D:/Project/IdeaProjects/spring-boot/spring-boot-project/spring-boot-tools/spring-boot-loader/target/classes/org/springframework/boot/loader/LaunchedURLClassLoader.class
				for (URL url : getURLs()) {
					try {
						URLConnection connection = url.openConnection();
						if (connection instanceof JarURLConnection) {
							// 获取Jar文件，例如file:/D:/Project/IdeaProjects/spring-boot/spring-boot-project/spring-boot-tools/spring-boot-loader/target/classes/org/springframework/boot/loader/LaunchedURLClassLoader.class
							// 对应的jar文件为 D:/Project/IdeaProjects/spring-boot/spring-boot-project/spring-boot-tools/spring-boot-loader/target/classes.jar
							JarFile jarFile = ((JarURLConnection) connection).getJarFile();
							// 检查 jar 文件中是否包含类和包的入口，以及清单文件是否存在。
							if (jarFile.getEntry(classEntryName) != null && jarFile.getEntry(packageEntryName) != null
									&& jarFile.getManifest() != null) {
								// 定义包，将清单文件关联到包中。例如 org.springframework.boot.loader.LaunchedURLClassLoader 对应的清单文件为 META-INF/MANIFEST.MF
								//我们就实现了通过 LaunchedURLClassLoader 加载 jar 包中内嵌的类 org.springframework.boot.loader.LaunchedURLClassLoader
								definePackage(packageName, jarFile.getManifest(), url);
								return null;
							}
						}
					}
					catch (IOException ex) {
						// Ignore
					}
				}
				return null;
			}, AccessController.getContext());
		}
		catch (java.security.PrivilegedActionException ex) {
			// Ignore
		}
	}

	/**
	 * Clear URL caches.
	 */
	public void clearCache() {
		for (URL url : getURLs()) {
			try {
				URLConnection connection = url.openConnection();
				if (connection instanceof JarURLConnection) {
					clearCache(connection);
				}
			}
			catch (IOException ex) {
				// Ignore
			}
		}

	}

	private void clearCache(URLConnection connection) throws IOException {
		Object jarFile = ((JarURLConnection) connection).getJarFile();
		if (jarFile instanceof org.springframework.boot.loader.jar.JarFile) {
			((org.springframework.boot.loader.jar.JarFile) jarFile).clearCache();
		}
	}

	private static class UseFastConnectionExceptionsEnumeration implements Enumeration<URL> {

		private final Enumeration<URL> delegate;

		UseFastConnectionExceptionsEnumeration(Enumeration<URL> delegate) {
			this.delegate = delegate;
		}

		@Override
		public boolean hasMoreElements() {
			Handler.setUseFastConnectionExceptions(true);
			try {
				return this.delegate.hasMoreElements();
			}
			finally {
				Handler.setUseFastConnectionExceptions(false);
			}

		}

		@Override
		public URL nextElement() {
			Handler.setUseFastConnectionExceptions(true);
			try {
				return this.delegate.nextElement();
			}
			finally {
				Handler.setUseFastConnectionExceptions(false);
			}
		}

	}

}
